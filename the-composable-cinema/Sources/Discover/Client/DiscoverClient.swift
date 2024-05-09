//
//  DiscoverClient.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Dependencies
import DependencyKeys
import Entities
import Network
import TMDBCore

struct DiscoverClient {
    var fetchMovies: () async throws -> [PaginationEntity]
    var fetchTVShows: () async throws -> [PaginationEntity]
}

extension DiscoverClient {
    private static func transform(response: TMDBDiscoverResponse) -> [PaginationEntity] {
       return response.items.compactMap { item in
           return PaginationEntity(entertainmentCategory: item.entertainmentCategory, response: item.response)
       }
   }
}

extension DiscoverClient: DependencyKey {
    static let liveValue: Self = {
        @Dependency(\.theMovieDatabaseClient) var tmdbClient
        return Self {
            let response = try await tmdbClient.fetchDiscover(categories: [.movies(.nowPlaying), .movies(.popular), .movies(.topRated)])
            return Self.transform(response: response)
        } fetchTVShows: {
            let response = try await tmdbClient.fetchDiscover(categories: [.tvShows(.onTheAir), .tvShows(.popular), .tvShows(.topRated)])
            return Self.transform(response: response)
        }
    }()
    
    static let testValue: Self = {
        @Dependency(\.theMovieDatabaseClient) var tmdbClient
        return Self {
            let response = try await tmdbClient.fetchDiscover(categories: [.movies(.nowPlaying), .movies(.popular), .movies(.topRated)])
            return Self.transform(response: response)
        } fetchTVShows: {
            let response = try await tmdbClient.fetchDiscover(categories: [.tvShows(.onTheAir), .tvShows(.popular), .tvShows(.topRated)])
            return Self.transform(response: response)
        }
    }()
  
}

extension DependencyValues {
    var discoverClient: DiscoverClient {
        get { self[DiscoverClient.self] }
        set { self[DiscoverClient.self] = newValue }
    }
}
