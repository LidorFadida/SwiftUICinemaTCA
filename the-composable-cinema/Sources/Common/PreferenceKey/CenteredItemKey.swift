//
//  CenteredItemKey.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI

public struct CenteredItemKey: PreferenceKey {
    public static var defaultValue: Int? = nil
    
    public static func reduce(value: inout Int?, nextValue: () -> Int?) {
        if let nextVal = nextValue() {
            value = nextVal
        }
    }
}
