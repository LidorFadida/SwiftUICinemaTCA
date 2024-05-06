//
//  TMDBCore.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Foundation

public final class TMDBCore {
    public static let shared = TMDBCore()
    internal var apiKey: String? = nil
    
    private init() {}
    
    public func configure(apiKey: String) {
        self.apiKey = apiKey
    }
}
