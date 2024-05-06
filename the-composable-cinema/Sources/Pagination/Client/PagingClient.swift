//
//  PagingClient.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Dependencies
import DependencyKeys
import Network
import TMDBCore
import TMDBMock
import Entities

public struct PaginationClient {
    public var fetchPage: (EntertainmentCategory, TMDBCoreProperties.Parameters) async throws -> PaginationEntity
    
    public init(fetchPage: @escaping (EntertainmentCategory, TMDBCoreProperties.Parameters) async throws -> PaginationEntity) {
        self.fetchPage = fetchPage
    }
}

extension PaginationClient: DependencyKey {
    public static let liveValue = Self { entertainmentCategory, parameters in
        @Dependency(\.theMovieDatabaseClient) var tmdbClient
        let response = try await tmdbClient.fetchTMDBPage(entertainmentCategory: entertainmentCategory, parameters: parameters)
        return PaginationEntity(entertainmentCategory: response.entertainmentCategory, response: response.response)
    }
    
    public static var testValue = Self { entertainmentCategory, parameters in
        let response = try await TMDBMocker().fetchTMDBPage(entertainmentCategory: entertainmentCategory, parameters: parameters)
        return PaginationEntity(entertainmentCategory: response.entertainmentCategory, response: response.response)
    }
}

extension DependencyValues {
    public var paginationClient: PaginationClient {
        get { self[PaginationClient.self] }
        set { self[PaginationClient.self] = newValue }
    }
}
