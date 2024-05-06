//
//  CategoryPaginationFeatureTests.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 06/05/2024.
//

import XCTest
import ComposableArchitecture
import CategoryPagination
import Pagination
import Entities

@MainActor
final class CategoryPaginationFeatureTests: XCTestCase {

    func testTrendingCategoryPagination() async {
        let discoverEntityFirstItem = withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid
            return DiscoverItemEntity(id: uuid().uuidString,
                                      itemIdentifier: 1,
                                      title: "Lidor",
                                      rating: 0.0,
                                      releaseDate: "",
                                      backdropPath: nil,
                                      posterPath: nil)
        }
        
        let paginationClient = withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid
            return PaginationClient { entertainmentCategory, parameters in
                return .init(id: uuid().uuidString,
                             title: "Test",
                             page: 1,
                             totalPages: 1,
                             entertainmentCategory: entertainmentCategory,
                             items: [discoverEntityFirstItem])
            }
        }

        
        
        let store = TestStore(initialState: CategoryPaginationFeature.State(entertainmentCategory: .movies(.trending))) {
            return CategoryPaginationFeature()
        } withDependencies: { container in
            container.paginationClient = paginationClient
        }
        
        await store.send(.pagination(.view(.fetchInitialPage))) { state in
            state.pagination.isLoading = true
        }
        
        await store.receive(\.pagination) { state in
            state.pagination.isLoading = false
            state.pagination.totalPages = 1
            state.pagination.items = [discoverEntityFirstItem]
        }
        
        await store.receive(\.pagination.reachedTotalPages)
    }
    
    func testCategoryPaginationInitialFetch() async {
        let discoverEntityFirstItem = withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            @Dependency(\.uuid) var uuid
            return DiscoverItemEntity(id: uuid().uuidString,
                                      itemIdentifier: 1,
                                      title: "Lidor",
                                      rating: 0.0,
                                      releaseDate: "",
                                      backdropPath: nil,
                                      posterPath: nil)
        }
        
        let store = TestStore(initialState: CategoryPaginationFeature.State(entertainmentCategory: .movies(.trending), pagination: .init(items: [discoverEntityFirstItem]))) {
            return CategoryPaginationFeature()
        }
        
        await store.send(.pagination(.view(.fetchInitialPage))) { state in
            state.pagination.isLoading = true
        }
    }

}
