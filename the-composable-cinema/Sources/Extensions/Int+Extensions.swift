//
//  Int+Extensions.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public extension Int {
    
    /// Converts an integer (total minutes) into a formatted string "Xh Ymin".
    /// It omits the hour or minute part if they are zero unless both are zero the output is 'Unavailable'.
    func formattedDuration() -> String {
        let hours = self / 60
        let minutes = self % 60

        var formattedString = ""

        if hours > 0 {
            formattedString += "\(hours)h"
        }
        
        if minutes > 0 {
            if !formattedString.isEmpty {
                formattedString += " "
            }
            formattedString += "\(minutes)min"
        }

        if formattedString.isEmpty {
            return "Unavailable" // or return "0h 0min" if you prefer it explicit
        }
        
        return formattedString
    }
}

