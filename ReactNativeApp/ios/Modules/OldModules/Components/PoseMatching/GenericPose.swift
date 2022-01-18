//
//  GenericPose.swift
//  jogo
//
//  Created by arham on 15/07/2021.
//

import Foundation

class GenericPose<T: Any>: BasePose {
  // The optional casting and then force unwrapping them is just to shutup embold and swiftLint.
  // Why we are using force-casting here and why it is valid here:
  // We know that generic pose will always be called via the PersonPose object and it is not accessible via
  // any other class/object type thus this force casting and unwrapping will never give an error if it
  // is used correctly.
  
  public func leftOf(d1: ObjectDetection, d2: ObjectDetection) -> T {
    y(subpose: { d1.getX() ?? 1000 < d2.getX() ?? -1000 }, poseTag: "\(d1.label) < \(d2.label)")
    return (self as? T)!
  }
  
  public func leftOf(d1: ObjectDetection, d2: Double) -> T {
    y(subpose: { d1.getX() ?? 1000 < d2 }, poseTag: "\(d1.label) < \(d2)")
    return (self as? T)!
  }
  
  public func rightOf(d1: ObjectDetection, d2: ObjectDetection) -> T {
    y(subpose: { d1.getX() ?? -1000 > d2.getX() ?? 1000 }, poseTag: "\(d1.label) > \(d2.label)")
    return (self as? T)!
  }
  
  public func rightOf(d1: ObjectDetection, d2: Double) -> T {
    y(subpose: { d1.getX() ?? -1000 > d2 }, poseTag: "\(d1.label) > \(d2)")
    return (self as? T)!
  }
  
  public func above(d1: ObjectDetection, d2: ObjectDetection) -> T {
    y(subpose: { d1.getY() ?? 1000 < d2.getY() ?? -1000 }, poseTag: "\(d1.label) ^ \(d2.label)")
    return (self as? T)!
  }
  
  public func above(d1: ObjectDetection, height: Double) -> T {
    y(subpose: { d1.getY() ?? 1000 < height }, poseTag: "\(d1.label) < \(height)")
    return (self as? T)!
  }
  
  public func below(d1: ObjectDetection, d2: ObjectDetection) -> T {
    y(subpose: { d1.getY() ?? -1000 > d2.getY() ?? 1000 }, poseTag: "\(d1.label) v \(d2.label)")
    return (self as? T)!
  }
  
  public func below(d1: ObjectDetection, height: Double) -> T {
    y(subpose: { d1.getY() ?? -1000 > height }, poseTag: "\(d1.label) v \(height)")
    return (self as? T)!
  }  
  
}
