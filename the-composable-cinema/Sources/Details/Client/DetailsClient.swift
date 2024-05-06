//
//  DetailsClient.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Dependencies
import DependencyKeys
import TMDBCore
import TMDBMock
import Entities

struct DetailsClient {
    var fetchDetails: (Int, EntertainmentCategory) async throws -> DetailsEntity
}

extension DetailsClient: DependencyKey {
    static let liveValue = Self { itemIdentifier, entertainmentCategory in
        @Dependency(\.theMovieDatabaseClient) var tmdbClient
        let response = try await tmdbClient.fetchDetails(id: itemIdentifier, entertainmentCategory: entertainmentCategory)
        let details = DetailsEntity(itemDetailsResponse: response)
        return details
    }
    
    static let testValue = Self { itemIdentifier, entertainmentCategory in
        let response = try await TMDBMocker().fetchDetails(id: itemIdentifier, entertainmentCategory: entertainmentCategory)
        let details = withDependencies { container in
            container.uuid = .incrementing
        } operation: {
             DetailsEntity(itemDetailsResponse: response)
        }
        return details
    }
}

extension DependencyValues {
    var detailsClient: DetailsClient {
        get { self[DetailsClient.self] }
        set { self[DetailsClient.self] = newValue }
    }
}
