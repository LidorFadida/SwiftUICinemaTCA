//
//  UIFont+Extensions.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import UIKit

public enum SanFransiscoFontWeight: String, CaseIterable {
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
    case heavy = "Heavy"
    case black = "Black"
}

public extension UIFont {
    
    static func sfProDisplay(weight: SanFransiscoFontWeight, _ size: CGFloat) -> UIFont {
        let fontName = "SFProDisplay-\(weight.rawValue)"
        guard let font = UIFont(name: fontName, size: size) else {
            print("🤖", #function, "Failed to load font")
            return .systemFont(ofSize: size)
        }
        return font
    }
    
    static func changaOne(_ size: CGFloat) -> UIFont {
        let fontName = "ChangaOne"
        guard let font = UIFont(name: fontName, size: size) else {
            print("🤖", #function, "Failed to load font")
            return .systemFont(ofSize: size)
        }
        return font
    }
}
