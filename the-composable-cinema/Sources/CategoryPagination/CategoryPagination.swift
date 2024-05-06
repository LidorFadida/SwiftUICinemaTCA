//
//  CategoryPaginationFeature.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//


import ComposableArchitecture
import TMDBCore
import Entities
import Pagination

///Stand alone (self fetching) pagination feature
///
///__PaginationFeature-DiscoverItemEntity-__ can be used via self.scope(state: \.pagination, action: \.pagination)
@Reducer
public struct CategoryPaginationFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public let entertainmentCategory: EntertainmentCategory
        public var pagination: PaginationFeature<DiscoverItemEntity>.State
        
        public init(
            entertainmentCategory: EntertainmentCategory,
            pagination: PaginationFeature<DiscoverItemEntity>.State = .init()
        ) {
            self.entertainmentCategory = entertainmentCategory
            self.pagination = pagination
        }
    }
    
    public enum Action: Equatable {
        case pagination(PaginationFeature<DiscoverItemEntity>.Action)
    }
    
    @Dependency(\.paginationClient) var paginationClient
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.pagination, action: \.pagination) {
            PaginationFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .pagination(action):
                switch action {
                case .view(.fetchInitialPage):
                    guard state.pagination.items.isEmpty else { return .none }
                    return fetch(state: state, page: 1)
                case let .fetchNextPage(page):
                    return fetch(state: state, page: page)
                default: return .none
                }
            }
        }
    }
    
    private func fetch(state: State, page: Int) -> Effect<Action> {
        return .run { [entertainmentCategory = state.entertainmentCategory] send in
            do {
                let parameters = TMDBCoreProperties.Parameters(page: page)
                let pagination = try await paginationClient.fetchPage(entertainmentCategory, parameters)
                await send(.pagination(.receivedPage(pagination.page, pagination.totalPages, pagination.items)))
            } catch { assertionFailure(error.localizedDescription) }
        }
    }
}
