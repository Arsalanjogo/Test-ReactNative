//
//  UtilArray.swift
//  jogo
//
//  Created by arham on 08/03/2021.
//

// Currently being used for DetectionLocation, InfoBlob, Integer and BoxLocation

import Foundation

enum UtilArrayError: Error {
  case ArraySizeLargerThanMaxSize
  case RequestedIndexDoesIsOutOfBound
  
}
// A stack or a queue
public enum POP {
  case FIFO
  case LIFO
}

public class UtilArrayList<E: Any> {
  // Custom Thread-Safe Array Data Handler.
  // Allows you save a variety of object and perform CRUD operations to
  // them safely.
  private var MAXSIZE: Int = 100
  private var maxSize: Int = -1
  private var popmethod: POP = POP.FIFO
  private var arrayList: [E] = [E]()
  private var reverseArrayList: [E] = [E]()
  private var arraySize: Int
  private let accessQ = dispatch_queue_concurrent_t.init(label: "SyncArray_\(UUID().uuidString)")
  
  // MARK: Lifecycle
  public init(values: [E]) {
    self.maxSize = values.count
    self.arraySize = 0
    self.addArray(value: values)
    self.reserveCapacity(capacity: maxSize)
  }
  
  init(maxSize: Int, popmethod: POP) {
    self.maxSize = maxSize
    self.arraySize = 0
    self.popmethod = popmethod
    self.reserveCapacity(capacity: maxSize)
  }
  
  init(maxSize: Int) {
    self.maxSize = maxSize
    self.arraySize = 0
    self.reserveCapacity(capacity: maxSize)
  }
  
  init() {
    self.maxSize = -1
    self.arraySize = 0
    self.setMaxSize(value: self.maxSize)
    self.reserveCapacity(capacity: MAXSIZE)
  }
  
  private func reserveCapacity(capacity: Int) {
    self.arrayList.reserveCapacity(MAXSIZE)
    self.reverseArrayList.reserveCapacity(MAXSIZE)
  }
  
  // MARK: Properties Get
  
  public func count() -> Int {
    return self.arraySize
  }
  
  public func isEmpty() -> Bool {
    return self.arraySize == 0
  }
  
  public func isFull() -> Bool {
    return self.arraySize == self.maxSize
  }
  
  private func capacity() -> Int {
    var capacity: Int?
    self.accessQ.sync(flags: .barrier) {
      capacity = self.arrayList.capacity
    }
    return capacity ?? 0
  }
  
  public func getMaxSize() -> Int {
    return self.maxSize
  }
  
  // MARK: Properties Set
  
  public func setMaxSize(value: Int = -1) {
    if value == -1 {
      self.maxSize = MAXSIZE
      return
    }
    self.maxSize = value
  }
  
  // MARK: Insertion Mechanism
  private func pop() {
    switch self.popmethod {
    case POP.FIFO:
      if !self.isEmpty() {
        self.arrayList.removeFirst()
        self.reverseArrayList.removeLast()
        self.arraySize -= 1
      }
    case POP.LIFO:
      if !self.isEmpty() {
        self.arrayList.removeLast()
        self.reverseArrayList.removeFirst()
        self.arraySize -= 1
      }
    }
  }
  
  public func popcheck() {
    while self.maxSize != -1 && self.isFull() {
      self.pop()
    }
  }
  
  public func add(index: Int, value: E) {
    self.accessQ.sync(flags: .barrier) {
      self.popcheck()
      self.arrayList.append(value)
      self.reverseArrayList.insert(value, at: 0)
      self.arraySize += 1
    }
  }
  
  public func add(value: E) -> Bool {
    self.add(index: 0, value: value)
    return true
  }
    
  public func addArray(value: [E]) {
//    let len: Int = value.count - 1
//    let arrayLen: Int = self.arrayList.count - 1
//    if len <= arrayLen {
//      for _ in 0...len {
//        self.popcheck()
//      }
//      self.arrayList.append(contentsOf: value)
//      self.reverseArrayList.insert(contentsOf: value.reversed(), at: 0)
//      self.arraySize += len
//    } else if len > arrayLen && arrayLen >= 1 {
//      for _ in 0...arrayLen {
//        self.popcheck()
//      }
//      self.arrayList.append(contentsOf: value)
//      self.reverseArrayList.insert(contentsOf: value, at: 0)
//      self.arraySize += len
//    } else {
//      self.arrayList.append(contentsOf: value)
//      self.reverseArrayList.insert(contentsOf: value, at: 0)
//      self.arraySize += len
//    }
    value.forEach { (element) in
      _ = self.add(value: element)
    }
  }
  
  // MARK: Get the largest value
  public func getMax(comparator: (E, E) throws -> Bool) -> E? {
    var max: E?
    self.accessQ.sync(flags: .barrier) {
      do {
        max = try self.arrayList.max(by: comparator)
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error)
        max = nil
      }
    }
    return max
  }
  
  // MARK: Get the smallest value
  public func getMin(comparator: (E, E) throws -> Bool) -> E? {
    var min: E?
    self.accessQ.sync(flags: .barrier) {
      do {
        min = try self.arrayList.min(by: comparator)
      } catch {
        Logger.shared.logError(logType: .ERROR, error: error)
        min = nil
      }
    }
    return min
  }
  
  // MARK: Get value logic
  func commonThrow() throws {
    if self.maxSize != -1 && self.count() > self.maxSize {
      throw UtilArrayError.ArraySizeLargerThanMaxSize
    }
  }
  
  public func get(index: Int) throws -> E {
    try commonThrow()
    var value: E?
    self.accessQ.sync {
      value = self.arrayList[index]
    }
    return value!
  }
  
  public func getLast() throws -> E? {
    try commonThrow()
    if self.isEmpty() {
      return nil
    }
    var value: E?
    self.accessQ.sync {
      value = self.reverseArrayList.first
    }
    return value
  }
  
  public func get() -> [E] {
    var value: [E]?
    self.accessQ.sync {
      value = self.arrayList
    }
    return value!
  }
  
  public func getReversed() -> [E] {
    var value: [E]?
    self.accessQ.sync {
      value = self.reverseArrayList
    }
    return value!
  }
  
  public func clear() {
    self.accessQ.sync(flags: .barrier) {
      self.arrayList.removeAll()
      self.reverseArrayList.removeAll()
      self.arraySize = 0
    }
  }
  
  public func filter(filter: (_ element: E) -> Bool) {
    self.arrayList = self.arrayList.filter { E in
      filter(E)
    }
    
    self.reverseArrayList = self.reverseArrayList.filter({ E in
      filter(E)
    })
  }
}
