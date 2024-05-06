//
//  SearchClient.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Dependencies
import Network
import TMDBCore
import Entities
import Alamofire
import DependencyKeys

public struct SearchClient {
    public var fetchPage: (String, Int, EntertainmentCategory) async throws -> PaginationEntity?
    
    public init(fetchPage: @escaping (String, Int, EntertainmentCategory) async throws -> PaginationEntity?) {
        self.fetchPage = fetchPage
    }
}

extension SearchClient: DependencyKey {
    public static let liveValue = Self { searchQuery, page, entertainmentCategory in
        do {
            @Dependency(\.theMovieDatabaseClient) var tmdbClient
            let parameters = TMDBCoreProperties.Parameters(page: page, searchQuery: searchQuery)
            let result = try await tmdbClient.fetchTMDBPage(entertainmentCategory: entertainmentCategory, parameters: parameters)
            return PaginationEntity(entertainmentCategory: result.entertainmentCategory, response: result.response)
        } catch {
            switch error {
            case AFError.explicitlyCancelled, is CancellationError:
                print("🤖", #function, "Paging request has been explicitly cancelled")
                return nil
            default:
                assertionFailure(error.localizedDescription)
                throw error
            }
        }
    }
    
    public static let testValue = Self { searchQuery, page, entertainmentCategory in
        @Dependency(\.uuid) var uuid
        let discoverEntityFirstItem = DiscoverItemEntity(id: uuid().uuidString,
                                                         itemIdentifier: 1,
                                                         title: "Lidor",
                                                         rating: 0.0,
                                                         releaseDate: "",
                                                         backdropPath: nil,
                                                         posterPath: nil)
        let discoverEntitySecondItem = DiscoverItemEntity(id: uuid().uuidString,
                                                          itemIdentifier: 1,
                                                          title: "Lidor",
                                                          rating: 0.0,
                                                          releaseDate: "",
                                                          backdropPath: nil,
                                                          posterPath: nil)
        switch page {
        case 1:
            return .init(id: uuid().uuidString,
                         title: "Test",
                         page: 1,
                         totalPages: 2,
                         entertainmentCategory: .movies(.search),
                         items: [discoverEntityFirstItem])
        case 2:
            return .init(id: uuid().uuidString,
                         title: "Test",
                         page: 2,
                         totalPages: 2,
                         entertainmentCategory: .movies(.search),
                         items: [discoverEntitySecondItem])
        default: fatalError()
        }
    }
}

extension DependencyValues {
    public var searchClient: SearchClient {
        get { self[SearchClient.self] }
        set { self[SearchClient.self] = newValue }
    }
}
