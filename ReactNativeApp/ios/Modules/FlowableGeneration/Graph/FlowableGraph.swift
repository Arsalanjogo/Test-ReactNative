//
//  FlowableGraph.swift
//  jogo
//
//  Created by arham on 14/11/2021.
//

import Foundation


enum GraphState {
  case DONE
  case STUCK
  case START
  case STOPPED
}

class FlowableGraph: CleanupProtocol {
  
  private var cycles: Int = 0
  weak private var current_node: Flowable?

  private var triggers: [Flowable] = []
  private var calculators: [Flowable] = []
  private var actions: [Flowable] = []

  private var allFlowables: [Flowable] = []
  private var endFlowables: [Flowable] = []
  
  private var sortedGraph: [Flowable] = []
  
  private var graphState: GraphState = .START
  
  init() { }
  
  public func insertNodes(flowables: [Flowable]?) {
    guard let _flowables = flowables else { return }
    for flbl in _flowables {
      guard let _tag = flbl.tag else { continue }
      switch _tag {
      case .TRIGGER:
        self.triggers.append(flbl)
      case .CALCULATOR:
        self.calculators.append(flbl)
      case .ACTION:
        self.actions.append(flbl)
      }
    }
    self.allFlowables = _flowables
    self.topologicallySortGraph()
  }
  
  /// Runs the graph created and increments an iteration count.
  /// 1. Processes all the trigger flowables.
  /// 2. Resets all the Calculator flowables as calculators should be cleared of inputs and outputs.
  /// 3. Increment the cycle count for the flowables.
  public func process() {
    if self.graphState == .STOPPED { return }
    cycles += 1
    // Allows a complete cycle of the graph to be run IF all the nodes are properly connected with each other.
    self.sortedGraph.forEach { flbl in
      flbl.process()
    }
    
    //End Logic for any Flowables if it has them.
    self.sortedGraph.forEach { flbl in
      flbl.endLogic()
    }
    
    // Updates the state of the graph flowables after one complete cycle of the graph.
    self.sortedGraph.forEach { flbl in
      flbl.validateStatus()
    }
    
    self.sortedGraph.forEach { flbl in
      flbl.graphCycleComplete(value: cycles)
    }
  }
  
  func insertIntoGraph(graph: [Flowable], node: Flowable) -> [Flowable] {
    var _graph = graph
    _graph.removeAll { flbl in
      flbl.uid == node.uid
    }
    _graph.append(node)
    return _graph
  }
  
  
  /// Sort the flowables in such an order that all flowables which are dependencies
  /// of the current flowables are already processed at that point.
  ///
  /// https://en.wikipedia.org/wiki/Topological_sorting
  /// Kahn's algorithm.
  ///
  /// The following are the steps being taken:
  /// 1. Create a hashmap of of the following syntax: [node_uid: [input_node_uid...]]
  /// 2. Create an empty list [graph] for the sorted graph and another list/set [S] which has all the nodes with 0 input connections.
  /// 3. If S has elements in it:
  ///     a. Pop it
  ///     b. Insert into graph
  ///     c. Iterate through the graph and get all the next nodes.
  ///     d. Remove the connections_touched element for popped node 2 current next node.
  ///     e. See if the connections_touched array for that node uid is empty.
  ///     f. If it is empty, append the current next node into S so that it will get in line to be inserted into the graph.
  /// 4. Normally, it is S that is to be a Set but here the graph is modelled as a Set, even though it is a List. 
  public func topologicallySortGraph() {
    
    // Step 0.5.
    var connectionsTouched: [String: [String]] = self.preProcessSorting()
    
    // Step 1.
    var edgeLessFlowables: [Flowable] = []
    var graph: [Flowable] = []
    (graph, edgeLessFlowables) = self.createInitialStructures()
    
    // Step 2.
    while !edgeLessFlowables.isEmpty {
      let flbl = edgeLessFlowables.removeFirst()
      graph = self.insertIntoGraph(graph: graph, node: flbl)
      
      // If the flowable does not have output ports, we don't necessarily need to perform all the next actions.
      // If the current flowable does not have any more input connections, don't do all of the below stuff.
      guard let outputPorts = flbl.output_ports else { continue }
      
      // Iterate through all of the next Flowables.
      (connectionsTouched, edgeLessFlowables) = walkThroughGraph(outputPorts: outputPorts,
                                                                 connectionsTouched: connectionsTouched,
                                                                 flowable: flbl,
                                                                 edgeLessFlowables: edgeLessFlowables)
    }
    if self.allFlowables.count != graph.count {
      Logger.shared.log(logType: .ERROR,
                        message: "\(self.allFlowables.count) != \(graph.count). The sorted graph has some serious issues in there.")
    }
    self.sortedGraph = graph
  }
  
  func walkThroughGraph(outputPorts: [PortProtocol],
                        connectionsTouched: [String: [String]],
                        flowable: Flowable, edgeLessFlowables: [Flowable]) -> ([String: [String]], [Flowable]) {
    var _connectionsTouched = connectionsTouched
    var _edgeLessFlowables = edgeLessFlowables
    
    for output_port in outputPorts {
      if output_port.portIOType == .UNDEFINED { continue }
      for inputPort in output_port.nextPortReference {
        if inputPort.isEnd { continue }
        let baseFlowable = inputPort.get_base_flowable()
        _connectionsTouched[baseFlowable.uid]?.removeAll(where: {uid in uid == flowable.uid})
        if _connectionsTouched[baseFlowable.uid]?.isEmpty ?? false { _edgeLessFlowables.append(baseFlowable) }
      }
    }
    return (_connectionsTouched, _edgeLessFlowables)
  }
  

  
  
  /// Primary func:
  /// 1. Inserts any trigger flowables into the graph list which has no input ports.
  /// returns the graph list: [Flowable]
  private func createInitialStructures() -> ([Flowable], [Flowable]) {
    var graph: [Flowable] = []
    var fList: [Flowable] = []
    for i in 0..<self.triggers.count {
      let trigger: Flowable = self.triggers[i]
      guard let iports = trigger.input_ports else {
        fList.append(trigger)
        continue }
      if !iports.isEmpty { continue }
      fList.append(trigger)
    }
    return (graph, fList)
  }
  
  /// Primary Functionality:
  /// 1. Creates a dictionary of flowable uids. Where
  /// keys: flowable uid
  /// value: [uids] where these uids are for input ports.
  /// Secondary functionality:
  /// 2. Populates the endFlowables list while parsing through the input ports of the all flowables.
  private func preProcessSorting() -> [String: [String]] {
    var connections: [String: [String]] = [:]
    for flowable in allFlowables {
      connections[flowable.uid] = []
      for input_port in flowable.input_ports! {
        if input_port.isEnd {
          endFlowables.append(flowable)
          continue }
        if input_port.portIOType == .UNDEFINED {
          continue
        }
        connections[flowable.uid]?.append(input_port.previousPortReference!.get_base_flowable().uid)
      }
    }
    return connections
  }
  
  public func cleanup() {
    self.graphState = .STOPPED
    for flbl in self.allFlowables {
      flbl.cleanup()
    }
    self.triggers = []
    self.calculators = []
    self.actions = []
    self.allFlowables = []
  }
  
  deinit { }
  
}
