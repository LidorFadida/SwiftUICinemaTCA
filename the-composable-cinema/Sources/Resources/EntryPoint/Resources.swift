//
//  Resources.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import UIKit

public final class Resources {
    
    public static func configure() {
        registerCustomFonts()
    }
    
    private static func registerCustomFonts() {
        registerSanFransiscoFont()
        registerChangaOneFont()
    }
    
    private static func registerSanFransiscoFont() {
        let sanFransiscoWeights = SanFransiscoFontWeight.allCases
        sanFransiscoWeights
            .map { $0.rawValue }
            .forEach { fontWeight in
                registerFont(forResource: "SF-Pro-Display-\(fontWeight)", ofType: "otf")
            }
    }
    
    private static func registerChangaOneFont() {
        registerFont(forResource: "ChangaOne-Regular", ofType: "ttf")
    }
    
    @discardableResult
    private static func registerFont(forResource: String, ofType: String) -> Bool {
        guard let fontPath = Bundle.module.path(forResource: forResource, ofType: ofType) else { return false }
        guard let fontData = NSData(contentsOfFile: fontPath) else { return false }
        guard let fontDataProvider = CGDataProvider(data: fontData) else { return false }
        guard let customFont = CGFont(fontDataProvider) else { return false }
        
        return CTFontManagerRegisterGraphicsFont(customFont, nil)
    }
}

