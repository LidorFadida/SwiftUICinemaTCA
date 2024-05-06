//
//  PaginationFeatureTests.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 06/05/2024.
//

import XCTest
import Pagination
import ComposableArchitecture


final class PaginationFeatureTests: XCTestCase {
    
    fileprivate struct Entity: Equatable, Identifiable {
        let id: String
        let name: String
    }
    
    
    @MainActor
    func testSinglePagePaginationFeature() async {
        let uuid = UUIDGenerator.incrementing
        var uuidString: String {
            return uuid().uuidString
        }
        let store = TestStore(initialState: PaginationFeature<Entity>.State()) {
            return PaginationFeature<Entity>()
        }
        
        await store.send(.view(.fetchInitialPage)) { state in
            state.isLoading = true
        }
        
        let entities: [Entity] = [.init(id: uuidString,
                                        name: "Lidor"),
                                  .init(id: uuidString,
                                        name: "Maayan"),
                                  .init(id: uuidString,
                                        name: "Niv")]
        let page = 1
        let totalPages = 1
        
        await store.send(.receivedPage(page, totalPages, entities)) { state in
            state.isLoading = false
            state.page = page
            state.totalPages = totalPages
            state.items = entities
        }
        
        ///receivedPage(:::) is already mutating isLoading to false before sending this action
        await store.receive(\.reachedTotalPages)
        
        await store.send(.view(.reachedLastItem)) { state in
            state.isLoading = true
        }
        
        await store.receive(\.reachedTotalPages) { state in
            state.isLoading = false
        }
        
        await store.send(.reset) { state in
            state.isLoading = false
            state.page = 1
            state.totalPages = 0
            state.items = []
        }
        
    }
    
    @MainActor
    func testMultiplePagesPaginationFeature() async {
        let uuid = UUIDGenerator.incrementing
        var uuidString: String {
            return uuid().uuidString
        }
        let store = TestStore(initialState: PaginationFeature<Entity>.State()) {
            return PaginationFeature<Entity>()
        } withDependencies: { container in
            container.uuid = .incrementing
        }
        
        await store.send(.view(.fetchInitialPage)) { state in
            state.isLoading = true
        }
        
        let entitiesFirstPage: [Entity] = [.init(id: uuidString,
                                                 name: "Lidor"),
                                           .init(id: uuidString,
                                                 name: "Maayan"),
                                           .init(id: uuidString,
                                                 name: "Niv")]
        let page = 1
        let totalPages = 2
        
        await store.send(.receivedPage(page, totalPages, entitiesFirstPage)) { state in
            state.isLoading = false
            state.page = page
            state.totalPages = totalPages
            state.items = entitiesFirstPage
        }
        
        await store.send(.view(.reachedLastItem)) { state in
            state.isLoading = true
        }
        
        await store.receive(\.fetchNextPage)
        
        let entitiesSecondPage: [Entity] = [.init(id: uuidString,
                                                  name: "Yaakov"),
                                            .init(id: uuidString,
                                                  name: "Ilana"),
                                            .init(id: uuidString,
                                                  name: "Yossi")]
        let secondPage = 2
        let items = entitiesFirstPage + entitiesSecondPage
        
        await store.send(.receivedPage(secondPage, totalPages, entitiesSecondPage)) { state in
            state.isLoading = false
            state.page = secondPage
            state.totalPages = totalPages
            state.items = items
        }
        
        await store.receive(\.reachedTotalPages)
        
        await store.send(.reset) { state in
            state.isLoading = false
            state.page = 1
            state.totalPages = 0
            state.items = []
        }
    }
    
    
}
