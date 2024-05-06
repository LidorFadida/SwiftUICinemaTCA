//
//  TMDBClientKey.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Dependencies
import Network
import TMDBMock

public enum TMDBClientKey: DependencyKey {
    public static let liveValue: any TMDBClientProtocol = TMDBClient()
    public static let testValue: any TMDBClientProtocol = TMDBMocker()
}

public extension DependencyValues {
    var theMovieDatabaseClient: any TMDBClientProtocol {
        get { self[TMDBClientKey.self] }
        set { self[TMDBClientKey.self] = newValue }
    }
}
