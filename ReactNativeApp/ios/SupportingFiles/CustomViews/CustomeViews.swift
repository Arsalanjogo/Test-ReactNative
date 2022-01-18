//
//  CustomeView.swift
//  jogo
//
//  Created by Mac Book on 25/07/2020.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.frame.height
        self.layer.cornerRadius = CGFloat(height / 2.0)
        self.clipsToBounds = true
    }
}

extension UIView {
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let viewWithTag = self.viewWithTag(1) {
            viewWithTag.removeFromSuperview()
        }
      if image != nil {
            return image!
        }
        return UIImage()
    }
}
