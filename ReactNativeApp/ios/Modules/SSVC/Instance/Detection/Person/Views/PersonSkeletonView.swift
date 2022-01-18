//
//  PersonSkeletonView.swift
//  Football433
//
//  Created by arham on 27/12/2021.
//

import Foundation
import UIKit

public class PersonSkeletonView: PersonView {
  
  override init(state: PersonState) {
    super.init(state: state)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func draw(canvas: UIView) {
    super.draw(canvas: canvas)
    guard let state = self.state as? PersonState else { return }
    drawSkeleton(canvas: canvas, personState: state)
  }
  
  func drawSkeleton(canvas: UIView, personState: PersonState) {
    personState.bones.forEach({ drawBoneDebug(canvas: canvas, bone: $0, color: ThemeManager.shared.theme.primaryColor) })
    personState.face?.bones.forEach({ drawBoneDebug(canvas: canvas, bone: $0, color: ThemeManager.shared.theme.primaryColor) })
    personState.leftArm?.bones.forEach({ drawBoneDebug(canvas: canvas, bone: $0, color: UIColor.red) })
    personState.rightArm?.bones.forEach({ drawBoneDebug(canvas: canvas, bone: $0, color: UIColor.blue) })
    personState.leftLeg?.bones.forEach({ drawBoneDebug(canvas: canvas, bone: $0, color: UIColor.red) })
    personState.rightLeg?.bones.forEach({ drawBoneDebug(canvas: canvas, bone: $0, color: UIColor.blue) })
  }
  
  func drawBoneDebug(canvas: UIView, bone: BoneState, color: UIColor) {
    
    guard let loc1 = bone.getBodyPart1().getLocation() else { return }
    guard let loc2 = bone.getBodyPart2().getLocation() else { return }
    
    if !loc1.locationKnown() || !loc2.locationKnown() { return }
    
    DrawingManager.get().drawLine(
      view: canvas,
      point1: CGPoint(
        x: loc1.getX(),
        y: loc1.getY()
      ),
      point2: CGPoint(
        x: loc2.getX(),
        y: loc2.getY()
      ),
      color: color
    )
  }
  
}
