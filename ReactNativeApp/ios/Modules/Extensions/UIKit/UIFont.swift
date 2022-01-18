//
//  UIFont.swift
//  jogo
//
//  Created by Muhammad Nauman on 01/07/2021.
//

import UIKit

extension UIFont {
  func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
  var boldItalicMono: UIFont {
    return withTraits(traits: [.traitBold, .traitItalic, .traitMonoSpace])
    }
}
