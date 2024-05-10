//
//  DiscoverFeatureTests.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 06/05/2024.
//

import ComposableArchitecture
import Discover
import TMDBCore
import TMDBMock
import Entities
import Pagination
import XCTest

@MainActor
final class DiscoverFeatureTests: XCTestCase {
    
    let mocker = TMDBMocker()
    
    func testMoviesDiscoverFeature() async {
        let discoverResponse = await withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            try! await mocker.fetchDiscover(categories: [.movies(.nowPlaying)]).items.compactMap { element in
                return PaginationEntity(entertainmentCategory: element.entertainmentCategory, response: element.response)
            }
        }
        
        let trendingEntertainment = EntertainmentCategory.movies(.trending)
        let store = TestStore(initialState: DiscoverFeature.State()) {
            DiscoverFeature(entertainmentCategory: .movies(.nowPlaying))
        } withDependencies: { container in
            container.uuid = .incrementing
        }
        
        await store.send(.view(.performInitialFetchIfNeeded)) { state in
            state.trending = .init(entertainmentCategory: trendingEntertainment)
        }
        await store.receive(\.sectionsResponse) { state in
            state.sections = discoverResponse
        }
    }
    
    func testTVShowsDiscoverFeature() async {
        let discoverResponse = await withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            try! await mocker.fetchDiscover(categories: [.tvShows(.onTheAir)]).items.compactMap { element in
                return PaginationEntity(entertainmentCategory: element.entertainmentCategory, response: element.response)
            }
        }

        
        let trendingEntertainment = EntertainmentCategory.tvShows(.trending)
        let store = TestStore(initialState: DiscoverFeature.State()) {
            DiscoverFeature(entertainmentCategory: .tvShows(.onTheAir))
        } withDependencies: { container in
            container.uuid = .incrementing
        }
        
        await store.send(.view(.performInitialFetchIfNeeded)) { state in
            state.trending = .init(entertainmentCategory: trendingEntertainment)
        }
        await store.receive(\.sectionsResponse) { state in
            state.sections = discoverResponse
        }
    }

}
