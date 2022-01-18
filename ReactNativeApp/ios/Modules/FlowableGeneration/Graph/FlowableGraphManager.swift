//
//  FlowableManager.swift
//  jogo
//
//  Created by arham on 20/10/2021.
//

import Foundation

class FlowableGraphManager: CleanupProtocol {
  
  private var exercise_definition_parser: ExerciseDefinitionParser?
  private var flowable_factory: FlowableFactory?
  
  private var flowables: [Flowable] = []
  private var flowableGraph: FlowableGraph = FlowableGraph()
  
  init(fileName: String) {
    exercise_definition_parser = ExerciseDefinitionParser(fileName: fileName)
    self.flowable_factory = FlowableFactory(portConnections: self.definePortConnections())
    self.buildFlowables()
    self.buildGraph()
    
  }
  
  private func loadCodable() -> _ExerciseDefiniton? {
    let edc: _ExerciseDefiniton? = self.exercise_definition_parser?.getDefinition()
    return edc!
  }
  
  private func definePortConnections() -> [PortConnections] {
    let _pipes: [_Pipe] = self.loadCodable()!.pipes
    return PortConnectionFactory.build(portConnections: _pipes)
  }
  
  private func buildFlowables() {
    let flbls: [_Flowable]? = self.loadCodable()?.flowables
    guard let _flbls = flbls else { return }
    guard let _flowable_factory = self.flowable_factory else { return }
    _flbls.forEach { _flbl in
      let flbl: Flowable = _flowable_factory
        .initializeFlowable(flblCodable: _flbl)
        .createPortMap()
        .build()
      self.flowables.append(flbl)
    }
  }
  
  public func buildGraph() {
    
    guard let _flowable_factory = flowable_factory else {
      return
    }
    
    self.flowables = self.flowables.map { flbl in flbl.setUpPorts() }
    self.flowables = _flowable_factory.connectFlowables(flowables: self.flowables)
    self.flowableGraph.insertNodes(flowables: self.flowables)
  }
  
  public func process() {
    self.flowableGraph.process()
  }
  
  public func cleanup() {
    self.exercise_definition_parser = nil
    self.flowable_factory = nil
    self.flowableGraph.cleanup()
    self.flowables = []
  }

}
