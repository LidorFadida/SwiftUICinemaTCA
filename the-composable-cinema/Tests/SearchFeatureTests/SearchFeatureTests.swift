//
//  SearchFeatureTests.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 06/05/2024.
//

import XCTest
import Search
import TMDBCore
import Pagination
import Entities
import ComposableArchitecture

@MainActor
final class SearchFeatureTests: XCTestCase {
    
    
    private var discoverEntityFirstItem: DiscoverItemEntity {
        return withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            DiscoverItemEntity(itemIdentifier: 1,
                               title: "Lidor",
                               rating: 0.0,
                               releaseDate: "",
                               backdropPath: nil,
                               posterPath: nil)
        }
    }

    private var discoverEntitySecondItem: DiscoverItemEntity {
        return withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            DiscoverItemEntity(itemIdentifier: 2,
                               title: "Lidor",
                               rating: 0.0,
                               releaseDate: "",
                               backdropPath: nil,
                               posterPath: nil)
        }
    }

    func testMoviesSearchFeature() async {
        let clock = TestClock()
        let discoverEntityFirstItem = discoverEntityFirstItem
        let containerEntertainment = EntertainmentCategory.movies(.nowPlaying)
        
        let store = TestStore(initialState: SearchFeature.State(pagination: PaginationFeature<DiscoverItemEntity>.State())) {
            return SearchFeature(entertainmentCategory: containerEntertainment)
        } withDependencies: { container in
            container.uuid = .incrementing
            container.continuousClock = clock
        }
        await store.send(.view(.toggleIsSearchActive)) { state in
            state.isSearchActive = true
        }
        
        let query = "Lidor Fadida"
        
        await store.send(.searchQueryChanged(query)) { state in
            state.searchQuery = query
        }
        
        await clock.advance(by: store.state.debounceInterval)
        
        await store.receive(\.reset)
        
        await store.receive(\.searchQueryChangeDebounced)
        
        await store.receive(\.pageResponse) { state in
            state.pagination.totalPages = 2
            state.pagination.items = [discoverEntityFirstItem]
        }
    }
    
    
    func testSearchNoResults() async {
        let clock = TestClock()
        
        let searchClient = SearchClient { searchQuery, page, entertainmentCategory in
            return withDependencies { container in
                container.uuid = .incrementing
            } operation: {
                PaginationEntity(title: "Test",
                                 page: 1,
                                 totalPages: 1,
                                 entertainmentCategory: .movies(.search),
                                 items: [])
            }
        }
        
        
        let containerEntertainment = EntertainmentCategory.movies(.nowPlaying)
        let store = TestStore(initialState: SearchFeature.State(pagination: PaginationFeature<DiscoverItemEntity>.State())) {
            return SearchFeature(entertainmentCategory: containerEntertainment)
        } withDependencies: { container in
            container.continuousClock = clock
            container.searchClient = searchClient
        }
        await store.send(.view(.toggleIsSearchActive)) { state in
            state.isSearchActive = true
        }
        
        let query = "Lidor Fadida"
        
        await store.send(.searchQueryChanged(query)) { state in
            state.searchQuery = query
        }
        
        await clock.advance(by: store.state.debounceInterval)
        
        await store.receive(\.reset)
        
        await store.receive(\.searchQueryChangeDebounced)
        
        await store.receive(\.pageResponse) { state in
            state.pagination.totalPages = 1
            state.pagination.items = []
            state.showNoResultForQueryMessage = true
        }
        
        await store.receive(\.pagination)
    }
    
    @MainActor
    func testSearchPaging() async {
        
        let clock = TestClock()
        let containerEntertainment = EntertainmentCategory.movies(.nowPlaying)
        let uuid = UUIDGenerator.constant(UUID())().uuidString
        let discoverEntityFirstItem = DiscoverItemEntity(id: uuid,
                                                         itemIdentifier: 1,
                                                         title: "Lidor",
                                                         rating: 0.0,
                                                         releaseDate: "",
                                                         backdropPath: nil,
                                                         posterPath: nil)
        let discoverEntitySecondItem = DiscoverItemEntity(id: uuid,
                                                          itemIdentifier: 1,
                                                          title: "Lidor",
                                                          rating: 0.0,
                                                          releaseDate: "",
                                                          backdropPath: nil,
                                                          posterPath: nil)
        
        let searchClient = SearchClient { searchQuery, page, entertainmentCategory in
            switch page {
            case 1:
                return .init(id: uuid,
                             title: "Test",
                             page: 1,
                             totalPages: 2,
                             entertainmentCategory: .movies(.search),
                             items: [discoverEntityFirstItem])
            case 2:
                return .init(id: uuid,
                             title: "Test",
                             page: 2,
                             totalPages: 2,
                             entertainmentCategory: .movies(.search),
                             items: [discoverEntitySecondItem])
            default: fatalError()
            }
        }
        
        let store = TestStore(initialState: SearchFeature.State(pagination: PaginationFeature<DiscoverItemEntity>.State())) {
            return SearchFeature(entertainmentCategory: containerEntertainment)
        } withDependencies: { container in
            container.continuousClock = clock
            container.searchClient = searchClient
        }
        await store.send(.view(.toggleIsSearchActive)) { state in
            state.isSearchActive = true
        }
        
        let query = "Lidor Fadida"
        
        await store.send(.searchQueryChanged(query)) { state in
            state.searchQuery = query
        }
        
        await clock.advance(by: store.state.debounceInterval)
        
        await store.receive(\.reset)
        
        await store.receive(\.searchQueryChangeDebounced)
        
        await store.receive(\.pageResponse) { state in
            state.pagination.totalPages = 2
            state.pagination.items = [discoverEntityFirstItem]
        }
        
        await store.send(.pagination(.view(.reachedLastItem))) { state in
            state.pagination.isLoading = true
        }
        await store.receive(\.pagination)
        
        
        await store.receive(\.pageResponse) {  state in
            state.pagination.page = 2
            state.pagination.items = [discoverEntityFirstItem, discoverEntitySecondItem]
            state.pagination.isLoading = false
        }
        await store.receive(\.pagination)
    }
            
}


