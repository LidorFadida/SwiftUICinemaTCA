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
    
    private struct Entity: Equatable, Identifiable {
        let id: String
        let name: String
        
        init(id: String, name: String) {
            self.id = id
            self.name = name
        }
        
        init(name: String) {
            @Dependency(\.uuid) var uuid
            self.id  = uuid().uuidString
            self.name = name
        }
    }
    
    private lazy var entitiesFirstPage: [Entity] = {
        return withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            return [.init(name: "Lidor"),
                    .init(name: "Maayan"),
                    .init(name: "Niv")]
        }
    }()
    
    private lazy var entitiesSecondPage: [Entity] = {
        return withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            return [.init(name: "Yaakov"),
                    .init(name: "Ilana"),
                    .init(name: "Yossi")]
        }
    }()
    
    
    @MainActor
    func testSinglePagePaginationFeature() async {
        let store = TestStore(initialState: PaginationFeature<Entity>.State()) {
            return PaginationFeature<Entity>()
        }
        
        await store.send(.view(.fetchInitialPage)) { state in
            state.isLoading = true
        }
        
        let entitiesFirstPage = entitiesFirstPage
        let page = 1
        let totalPages = 1
        
        await store.send(.receivedPage(page, totalPages, entitiesFirstPage)) { state in
            state.isLoading = false
            state.page = page
            state.totalPages = totalPages
            state.items = entitiesFirstPage
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
        let store = TestStore(initialState: PaginationFeature<Entity>.State()) {
            return PaginationFeature<Entity>()
        }
        
        await store.send(.view(.fetchInitialPage)) { state in
            state.isLoading = true
        }
        
        let entitiesFirstPage = entitiesFirstPage
        let entitiesSecondPage = entitiesSecondPage
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
