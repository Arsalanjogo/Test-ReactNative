//
//  UIView.swift
//  jogo
//
//  Created by arham on 12/08/2021.
//

import Foundation

extension UIView {
  
  /// Flip view horizontally.
  func flipX() {
    transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
  }
  
  /// Flip view vertically.
  func flipY() {
    transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
  }
}
