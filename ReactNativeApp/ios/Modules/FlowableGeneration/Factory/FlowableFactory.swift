//
//  FlowableFactory.swift
//  jogo
//
//  Created by arham on 21/10/2021.
//

import Foundation

class FlowableFactory {
  
  var portConnections: [PortConnections]?
  
  private var flblCodable: _Flowable?

  private var flowable: Flowable?
  private var inputPorts: [PortConnectionDefinition]?
  private var outputPorts: [PortConnectionDefinition]?
  
  init(portConnections: [PortConnections]) {
    self.portConnections = portConnections
  }
  
  public func initializeFlowable(flblCodable: _Flowable) -> FlowableFactory {
    self.flblCodable = flblCodable
    flowable = Flowable(name: flblCodable.name,
                        type: flblCodable.type,
                        subtype: flblCodable.subtype,
                        flowable_id: flblCodable.id,
                        uid: flblCodable.uid,
                        options: flblCodable.options)
    return self
  }
  
  public func createPortMap() -> FlowableFactory {
    guard let portConnections = self.portConnections else { return self }
    guard let flbl = flowable else { return self }
    var input_port_ids: Set<PortConnectionDefinition> = Set<PortConnectionDefinition>()
    var output_port_ids: Set<PortConnectionDefinition> = Set<PortConnectionDefinition>()
    for portConnection in portConnections {
      guard let toPortDef = portConnection.output_port_definition else { return self }
      guard let fromPortDef = portConnection.input_port_definition else { return self }
      if flbl.uid == toPortDef.flowable_id { input_port_ids.insert(toPortDef) }
      if flbl.uid == fromPortDef.flowable_id { output_port_ids.insert(fromPortDef) }
    }
    inputPorts = Array(input_port_ids)
    outputPorts = Array(output_port_ids)
    return self
  }
  
  public func build() -> Flowable {
    return flowable!
      .createLogic(inputPorts: inputPorts ?? [],
                   outputPorts: outputPorts ?? [])
      .setStateToInitialized()
  }
  
  public func clean() {
    flblCodable = nil
    flowable = nil
  }
  
  public func connectFlowables(flowables: [Flowable]) -> [Flowable] {
    var portsConnected: Int = 0
    var portCount: Int = 0
    guard let portConnections = self.portConnections else { return flowables }
    
    // Iterate through all the pipes a.k.a port connections.
    portConnections.forEach { portConnection in
      portCount += 1
      guard let ipipe = portConnection.output_port_definition else { return }
      guard let opipe = portConnection.input_port_definition else { return }
      var _iFlowable: Flowable?
      var _oFlowable: Flowable?
      
      // Identify flowables in the current list and save a reference of them in the above variables.
      (_iFlowable, _oFlowable) = self.getFlowablesForPipes(flowableList: flowables, ipipe: ipipe, opipe: opipe)
      
      // If there are not 2 flowables identified at this stage. The pipe has an error or the json itself.
      guard let iFlowable = _iFlowable else {
        Logger.shared.log(logType: .WARN, message: "PIPE: \(portConnection.input_port_definition.flowable_id) mismatched. No iFlowable found")
        return }
      guard let oFlowable = _oFlowable else {
        Logger.shared.log(logType: .WARN, message: "PIPE: \(portConnection.output_port_definition.flowable_id) mismatched. No oFlowable found")
        return }
      
      // Main logic for connecting 2 ports with each other.
      for iport in iFlowable.input_ports! {
        let iport_id = iport.uid
        if iport_id != ipipe.port_id { continue }
        portsConnected = connectPorts(iport: iport, oFlowable: oFlowable, opipe: opipe, portsConnected: portsConnected, portCount: portCount)
      }
    }
    return flowables
  }
  
  private func connectPorts(iport: PortProtocol,
                            oFlowable: Flowable,
                            opipe: PortConnectionDefinition,
                            portsConnected: Int,
                            portCount: Int) -> Int {
    var pCount: Int = 0
    for oport in oFlowable.output_ports! {
      let oport_id = oport.uid
      if oport_id != opipe.port_id { continue }
      iport.set_port_reference(port: oport, portType: .INPUT)
      oport.set_port_reference(port: iport, portType: .OUTPUT)
      pCount += 1
      Logger.shared.log(logType: .DEBUG, message: "Connected: \(oport.uid): \(iport.uid): \(portsConnected+pCount)/\(portCount)")
      break
    }
    return portsConnected+pCount
  }
  
  private func getFlowablesForPipes(flowableList: [Flowable], ipipe: PortConnectionDefinition, opipe: PortConnectionDefinition) -> (Flowable?, Flowable?) {
    var _iFlowable: Flowable?
    var _oFlowable: Flowable?
    flowableList.forEach { f in
      if f.uid == ipipe.flowable_id {
        _iFlowable = f
      } else if f.uid == opipe.flowable_id {
        _oFlowable = f
      }
    }
    return (_iFlowable, _oFlowable)
  }

}
