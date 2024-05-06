//
//  TMDBNetwork.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation
import NetworkLogger
import TMDBCore

public final class TMDBNetwork {
    public static let shared = TMDBNetwork()
    public var logger = NetworkActivityLogger.shared
    
    internal var sdkKey: String? = nil
    
    private init() {}
    
    public func configure(apiKey: String, logLevel: NetworkActivityLoggerLevel = .off) {
        TMDBCore.shared.configure(apiKey: apiKey)
        logger.level = logLevel
        if logLevel != .off { logger.startLogging() }
    }
}
