//
//  StringExtension.swift
//  jogo
//
//  Created by Admin on 18/06/2021.
//

import Foundation

extension String {
    func size(OfFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
    }
}
