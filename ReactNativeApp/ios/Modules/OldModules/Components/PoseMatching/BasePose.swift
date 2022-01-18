//
//  Pose.swift
//  jogo
//
//  Created by arham on 24/03/2021.
//

import Foundation

public class BasePose: CanDraw {
  // Saves functions for the specific matching scenarios.
  // Allows functionality to match these scenarios.
  
  typealias StringClosure = () -> String
  
  private final var ySubPose: [(SubPose, String)] = [(SubPose, String)]()
  private final var nSubPose: [(SubPose, String)] = [(SubPose, String)]()
  private final var extraDraw: [StringClosure] = [StringClosure]()
  
  // MARK: Yes and No poses for the Pose Matching module.
  @discardableResult
  public func y(subpose: @escaping SubPose, poseTag: String) -> BasePose {
    ySubPose.append((subpose, poseTag))
    return self
  }
  
  @discardableResult
  public func n(subpose: @escaping SubPose, poseTag: String) -> BasePose {
    nSubPose.append((subpose, poseTag))
    return self
  }
  
  @discardableResult
  public func y(subpose: @escaping SubPose, poseTag: String, inverse: SubPose) -> BasePose {
    ySubPose.append((subpose, poseTag))
    return self
  }
  
  @discardableResult
  public func n(subpose: @escaping SubPose, poseTag: String, inverse: SubPose) -> BasePose {
    nSubPose.append((subpose, poseTag))
    return self
  }
  
  @discardableResult
  internal func extraDraw(method: @escaping StringClosure) -> BasePose {
    self.extraDraw.append(method)
    return self
  }
  
  // MARK: Match the pose according to the properties Yes and No Property defined in the exercise.
  public func match() -> Bool {
    return ySubPose.map { $0.0() }
      .allSatisfy({ $0 }) &&
      nSubPose.map { !$0.0() }
      .allSatisfy({ $0 })
  }
  
  // MARK: Drawing
  func draw(canvas: UIView) {
    
  }
  
  func drawDebug(canvas: UIView) {
    ySubPose.forEach { (poseI, tagI) in
      DrawingManager.get().drawText(view: canvas, origin: nil, label: "\(tagI): \(poseI())")
    }
    nSubPose.forEach { (poseI, tagI) in
      DrawingManager.get().drawText(view: canvas, origin: nil, label: "\(tagI): \(poseI())")
    }
    extraDraw.forEach { (drawProperty) in
      DrawingManager.get().drawText(view: canvas, origin: nil, label: "\(drawProperty())")
    }
  }
}
