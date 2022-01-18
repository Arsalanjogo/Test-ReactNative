//
//  MemoryProfiler.swift
//  jogo
//
//  Created by arham on 09/09/2021.
//

import Foundation


class MemoryProfiler: ProfilerProtocol {
  
  private init() { }
  
  static func getTotal() -> Double {
    let info = self.memoryUsage()
    let bytesInMegabyte = 1024.0 * 1024.0
    let totalMemory = Double(info.total) / bytesInMegabyte
    return totalMemory
  }
  
  static func get() -> String {
    let info = self.memoryUsage()
    let bytesInMegabyte = 1024.0 * 1024.0
    let usedMemory = Double(info.used) / bytesInMegabyte
    let totalMemory = Double(info.total) / bytesInMegabyte
    let memory = String(format: "%.2f %", ((usedMemory / totalMemory) * 100))
    return memory
  }
  
  private static func memoryUsage() -> (used: UInt64, total: UInt64) {
    var taskInfo = task_vm_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
    let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
      $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
        task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
      }
    }
    
    var used: UInt64 = 0
    if result == KERN_SUCCESS {
      used = UInt64(taskInfo.phys_footprint)
    }
    
    let total = ProcessInfo.processInfo.physicalMemory
    return (used, total)
  }
  
}
