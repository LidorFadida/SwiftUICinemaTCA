//
//  Font+Extensions.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import SwiftUI

public extension SwiftUI.Font {
    
    static func from(uiFont: UIFont) -> SwiftUI.Font {
        return SwiftUI.Font(uiFont as CTFont)
    }
}
