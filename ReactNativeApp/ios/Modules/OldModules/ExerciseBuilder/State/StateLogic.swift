//
//  StateLogic.swift
//  jogo
//
//  Created by arham on 04/08/2021.
//

import Foundation


public class StateLogic {
  
  private var executableCalculator: Array<ExecutableCalculatorProtocol> = Array<ExecutableCalculatorProtocol>()
  
  
  init(val: [onState]) {
    val.forEach { onState in
      do {
        let val: ExecutableCalculatorProtocol = try ExecutableFactory.build(val: onState)
        executableCalculator.append(val)
      } catch {
        Logger.shared.log(logType: .ERROR, message: "Unable to create the Executable for the state.")
      }
    }
  }
  
  public func execute() {
    executableCalculator.forEach { ecp in
      do {
        try ecp.execute()
        
      } catch {
        Logger.shared.log(logType: .ERROR, message: "Unable to run \(ecp.debugString())")
      }
    }
  }
}
