//
//  DateFormatter+Extensions.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public extension DateFormatter {
    /// Converts a date string from "yyyy-MM-dd" format to "MMMM dd.yyyy" format.
    static func convertDateString(_ dateString: String?) -> String {
        guard let dateString = dateString else { return "Unavailable" }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM dd.yyyy"
            return outputFormatter.string(from: date)
        } else {
            return "Unavailable"
        }
    }
}
