//
//  DiscoverClient.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Dependencies
import DependencyKeys
import Entities

struct DiscoverClient {
    var fetchMovies: () async throws -> [PaginationEntity]
    var fetchTVShows: () async throws -> [PaginationEntity]
}

extension DiscoverClient: DependencyKey {
    static let liveValue: Self = {
        @Dependency(\.theMovieDatabaseClient) var tmdbClient
        return Self {
            let response = try await tmdbClient.fetchMovies()
            return response.items.compactMap { element in
                return PaginationEntity(entertainmentCategory: element.entertainmentCategory, response: element.response)
            }
        } fetchTVShows: {
            let response = try await tmdbClient.fetchTVShows()
            return response.items.compactMap { element in
                return PaginationEntity(entertainmentCategory: element.entertainmentCategory, response: element.response)
            }
        }
    }()
    
    static let testValue: Self = {
        @Dependency(\.theMovieDatabaseClient) var tmdbClient
        return Self {
            let response = try await tmdbClient.fetchMovies()
            return response.items.compactMap { element in
                return PaginationEntity(entertainmentCategory: element.entertainmentCategory, response: element.response)
            }
        } fetchTVShows: {
            let response = try await tmdbClient.fetchTVShows()
            return response.items.compactMap { element in
                return PaginationEntity(entertainmentCategory: element.entertainmentCategory, response: element.response)
            }
        }
    }()
}

extension DependencyValues {
    var discoverClient: DiscoverClient {
        get { self[DiscoverClient.self] }
        set { self[DiscoverClient.self] = newValue }
    }
}
