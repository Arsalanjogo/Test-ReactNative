//
//  ConeLocation.swift
//  jogo
//
//  Created by arham on 19/05/2021.
//

import Foundation


class ConeLocation: MovingLocation {
  //Location used for the Cones during exercises.
  // Cones can tip over and fall.
  // Cones can be activated and deactivated.

  let ANIMATIONTIME: Double = 300.0
  
  private var radius: Double
  private var active: Bool = false
  private final var fallOverLeft: Bool

  var fallOverTime: Double = 0
  var fallOverBool: Bool = false
  var cone: LottieCone?
  
  // MARK: Lifecycle
  init(radius: Double, centerX: Double, centerY: Double, fallOver: Bool, exerciseVC: ExerciseViewController) {

    self.radius = radius
    fallOverLeft = fallOver
    super.init(x: centerX, y: centerY)
    cone = try? LottieCone(exerciseVC: exerciseVC).move(x: CGFloat(self.getX()), y: CGFloat(self.getY())).play()
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  public func activate() -> ConeLocation {
    self.active = true
    return self
  }
  
  public func reset() {
    self.fallOverBool = false
  }
  
  public func fallOver() {
    fallOverTime = Date().getMilliseconds()
    fallOverBool = true
  }
  
  // MARK: Properties Get/Set
  public func isActive() -> Bool {
    return self.active
  }

  override func getRadius() -> Double {
    return self.radius
  }
  
  public func setRadius(radius: Double) {
    self.radius = radius
  }
  
  // MARK: Drawing Logic
  override func setY(value: Double) {
    super.setY(value: value)
    DispatchQueue.main.async {
      let _ = try? self.cone?.move(x: CGFloat(self.getX()), y: CGFloat(self.getY()))
    }
  }
  
  override func draw(canvas: UIView) {
    if !isActive() { return }
    
    if self.fallOverLeft {
      _ = self.fallOverBool ? self.cone?.fall(direction: .LEFT) : self.cone?.stand(from: .LEFT)
    } else {
      _ = self.fallOverBool ? self.cone?.fall(direction: .RIGHT) : self.cone?.stand(from: .RIGHT)
    }
    
  }
  
  override func drawDebug(canvas: UIView) {
    
  }
}
