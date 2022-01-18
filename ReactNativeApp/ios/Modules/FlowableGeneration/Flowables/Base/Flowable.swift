//
//  Flowable.swift
//  jogo
//
//  Created by arham on 20/10/2021.
//

import Foundation


/// Representation of the Flowable State.
/// Can be UNINITIALIZED even after init as the flowable has not been completely composed.
/// After being composed, the state will change to UNPROCESSED.
/// If the node has been processed in the cycle, will switch to PROCESSED.
/// When the exercise ends and the graph is being deinitialized, nodes can be sent to GC and have their states set to DEINITIALIZED.
/// DEINITIALIZED might have more usecases where the nodes can be activated and deactivated duing the graph cycling process.
enum FlowableStatus {
  case UNINITIATLIZED
  case UNPROCESSED
  case PROCESSED
  case STUCK
  case DONE
  case DEINITIALIZED
}

enum FlowableTag {
  case TRIGGER
  case CALCULATOR
  case ACTION
}

class Flowable: CleanupProtocol, Hashable {
  
  static func == (lhs: Flowable, rhs: Flowable) -> Bool {
    return lhs.uid == rhs.uid
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.uid)
  }
  
  public var description: String {
    return "Flowable: \(self.uid)"
  }
  
  /// Name of the flowable defined in the mapping
  /// Used to identify this specific node of the graph in the designer.
  internal var name: String
  
  /// The major type of flowables used to categorize them into unique section.
  /// Each type has their own separate maps.
  internal var type: String
  
  /// Each subtype is completely unique from all other flowables.
  /// Used to select the specific ports and logic from the respective Logic and PortMapping.swift
  internal var subtype: String
  
  /// An identifier for the flowable. Can be multiple nodes with this flowable id.
  internal var flowable_id: String
  
  /// The unique identifier for this specific instance of the flowable node.
  internal var uid: String
  
  /// User defined options of predefined parameters for the specific flowable.
  internal var options: [String: Any]?
  
  /// Allows the flowable to recieve data in the graph from their respective connected output ports.
  lazy internal var input_ports: [PortProtocol]? = []
  
  /// Allows the flowable to send data forward in the graph to their respective connected input ports.
  lazy internal var output_ports: [PortProtocol]? = []
  
  /// The main part of the flowable. Runs the designated command after the input ports have recieved their data.
  internal var logic: FlowableLogicProtocol?
  
  /// The cycle count of graph. Each flowable can have their own unique cycleCount to denote if it is synchronized with
  /// the other nodes of the graph.
  private var cycleCount: Int = 0
  
  /// State of the current node in the current cycle.
  private var status: FlowableStatus
  
  /// If this property is set to true, then it can perform the endLogic step in the graph.
  private var hasEndPorts: Bool?
  
  /// Index of the graph denoting when it will be processed in the sorted graph
  internal var nodeIndex: Int = -1
  
  internal var tag: FlowableTag?
  
  /// Can only be initialized as an empty shell with these following properties.
  init(name: String, type: String, subtype: String, flowable_id: String, uid: String, options: [String: Any]?) {
    self.name = name
    self.type = type
    self.subtype = subtype
    self.flowable_id = flowable_id
    self.uid = uid
    self.options = options
    self.status = .UNINITIATLIZED
  }
  
  /// Cycle Count:
  /// Implements the graph-usable property denoting the number of times this specific node has processed its calculation.
  /// Can be used to find out if the node is causing the bottlenecks.
  public func graphCycleComplete(value: Int) {
    if value > self.cycleCount {
      self.cycleCount = value
      self.logStatus()
      self.status = .UNPROCESSED
    }
  }
  
  public func validateStatus() {
    switch self.status {
    case .UNPROCESSED:
      self.status = .STUCK
    case .PROCESSED:
      self.status = .DONE
    case .DONE:
      Logger.shared.log(logType: .ERROR, message: "\(self.status) for \(self.uid) should not happen at this stage. Cycle Count: \(self.cycleCount)")
    case .STUCK:
      Logger.shared.log(logType: .ERROR, message: "\(self.status) for \(self.uid) should not happen at this stage")
    case .DEINITIALIZED:
      return
    case .UNINITIATLIZED:
      return
    }
    Logger.shared.log(logType: .DEBUG, message: "\(self.uid): \(self.cycleCount) -> \(self.status)")
  }
  
  public func logStatus() {
    var iports: [PortValuesCodable]?
    var oports: [PortValuesCodable]?
    
    
    for port in self.input_ports! {
      if iports == nil { iports = [] }
      let value: Any? = port.get()
      iports!.append(PortValuesCodable(name: port.port_id, value: "\(value ?? "nil")"))
    }
    for port in self.output_ports! {
      if oports == nil { oports = [] }
      let value: Any? = port.get()
      oports!.append(PortValuesCodable(name: port.port_id, value: "\(value ?? "nil")"))
    }
    GraphStatusJsonManager.get().saveStatusForFlowable(frameId: "\(self.cycleCount)", flowable_id: self.uid, value: FlowableStatusCodable(status: "\(self.status)", inputPorts: iports, outputPorts: oports))
  }
  
  /// Retrieves the current flowable's count for how many times it has the process() called.
  /// Does not denote the number of actual logic.process() func calls.
  public func getCycleCount() -> Int {
    return self.cycleCount
  }
  
  /// Allows a simple state update mechanism to update the fowable state during the graph cycles.
  internal func progressStatus() {
    // TODO: Implement the cyclical flow of the flowable logic in here and
    // add the other 
    switch self.status {
    case .UNINITIATLIZED:
      self.status = .UNPROCESSED
    case .UNPROCESSED:
      self.status = .PROCESSED
    case .PROCESSED:
      self.status = .DONE
    case .DONE:
      self.status = .UNPROCESSED
    case .STUCK:
      self.status = .UNPROCESSED
    case .DEINITIALIZED:
      return
    }
  }
  
  /// Removes all references stored in the flowable so that no memory leaks occur.
  internal func cleanup() {
    self.input_ports?.forEach({ port in
      port.cleanup()
    })
    self.output_ports?.forEach({ port in
      port.cleanup()
    })
    self.input_ports = nil
    self.output_ports = nil
    self.logic?.cleanup()
    self.logic = nil
  }
  
  internal func reset() {
    guard let input_ports = input_ports else { return }
    guard let output_ports = output_ports else { return }
    if self.status == .DONE {
      for iport in input_ports {
        iport.clear()
      }
      for oport in output_ports {
        oport.clear()
      }
    }
  }
  
  /// Check if data is present in the input ports.
  /// Run the logic.process()
  /// Send the data from the output ports.
  /// Clean the data in the input ports.
  internal func process() {
    if self.status == .PROCESSED {
      return
    }
    
    if self.input_ports != nil {
      if !self.input_ports!.isEmpty {
        self.input_ports!.map { iport in
          iport.getDataFromConnectedPort()
        }
        let allNotNil = self.input_ports!.map { iport in
          (!iport.isNull() || iport.isOptional)
        }.allSatisfy { v in v }
        if !allNotNil { return }
      }
    }
    
    let processed: Bool? = logic?.process()
    guard let _processed = processed else { return }
    if !_processed { return }
    self.status = .PROCESSED
    
    guard let oports = self.output_ports else {
      Logger.shared.log(logType: .ERROR, message: "Output Ports are null???")
      return }
//    for port in oports {
//      port.nextPortReference.map { nport in
//        Logger.shared.log(logType: .DEBUG, message: nport.get_uid())
//        nport.get_base_flowable().process()
//      }
//    }
  }
  
  internal func endLogic() {
    if hasEndPorts == nil {
      if self.input_ports != nil {
        hasEndPorts = self.input_ports!.map { iport in
          iport.isEnd
        }.contains(true)
      }
    }
    if self.input_ports != nil {
      if !self.input_ports!.isEmpty {
        self.input_ports!.map { iport in
          if iport.isEnd {
            iport.getDataFromConnectedPort()
          }
        }
      }
    }
    if hasEndPorts ?? false {
      self.logic?.endLogic()
    }
  }
  
  /*
   All functions below allow for the composition of the flowable.
   */
  

  
  /// Should be the last function call for the creation of the port step.
  internal func createLogic(inputPorts: [PortConnectionDefinition], outputPorts: [PortConnectionDefinition]) -> Flowable {
    let logicClass: BaseLogic.Type = LogicMapping.get(type: self.type, subtype: self.subtype)
    self.logic = logicClass.init(name: name, uid: self.uid, options: self.options, inputPorts: inputPorts, outputPorts: outputPorts)
    self.tag = self.logic?.tag
    return self
  }
  
  internal func setUpPorts() -> Flowable {
    self.input_ports = self.logic?.getInputPorts()
    self.output_ports = self.logic?.getOutputPorts()
    self.setRefereceForInputPorts()
    self.setReferenceForOutputPorts()
    return self
  }
  
  /// Sets the ports into the input Port array and then sets the port-flowable reference.
  private func setRefereceForInputPorts() {
    for port in self.input_ports! {
      port.set_base_flowable(flowable: self)
    }
  }
  
  /// Sets the ports into the input Port array and then sets the port-flowable reference.
  private func setReferenceForOutputPorts() {
    for port in self.output_ports! {
      port.set_base_flowable(flowable: self)
    }
  }
  
  /// Should be called
  internal func setStateToInitialized() -> Flowable {
    if self.status != .UNINITIATLIZED {
      self.status = .UNINITIATLIZED
    }
    self.progressStatus()
    return self
  }
  
}
