//
//  DiscoverFeature.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import ComposableArchitecture
import TMDBCore
import Entities
import Search
import Common
import CategoryPagination
import Pagination
import Details
import TMDBMock

@Reducer
public struct DiscoverFeature {
    public let entertainmentCategory: EntertainmentCategory
    
    public init(
        entertainmentCategory: EntertainmentCategory
    ) {
        self.entertainmentCategory = entertainmentCategory
    }
    
    @ObservableState
    public struct State: Equatable {
        public var path: StackState<Path.State>
        public var sections: [PaginationEntity]
        public var search: SearchFeature.State
        public var trending: CategoryPaginationFeature.State?
        public var highlightedItemIndex: Int?
        
        public init(
            path: StackState<Path.State> = StackState<Path.State>(),
            sections: [PaginationEntity] = [],
            search: SearchFeature.State = SearchFeature.State(pagination: PaginationFeature<DiscoverItemEntity>.State()),
            trending: CategoryPaginationFeature.State? = nil,
            highlightedItemIndex: Int? = nil
        ) {
            self.path = path
            self.sections = sections
            self.search = search
            self.trending = trending
            self.highlightedItemIndex = highlightedItemIndex
        }
    }
    
    public enum Action: ViewAction, Equatable {
        case sectionsResponse([PaginationEntity])
        case trending(CategoryPaginationFeature.Action)
        case search(SearchFeature.Action)
        case path(StackActionOf<Path>)
        case view(View)
    }
    
    @CasePathable
    public enum View: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case performInitialFetchIfNeeded
        case highlightedItemIndex(Int?)
        case seeAll(EntertainmentCategory)
        case details(Int)
    }
    
    @Dependency(\.discoverClient) var discoverClient
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.search, action: \.search) {
            SearchFeature(entertainmentCategory: entertainmentCategory)
        }
        
        Reduce { state, action in
            switch action {
            case let .sectionsResponse(paginationEntity):
                state.sections = paginationEntity
                return .none
            case let .trending(action):
                return trending(state: &state, action: action)
            case let .search(action):
                return search(state: &state, action: action)
            case let .path(action):
                return path(state: &state, action: action)
            case let .view(action):
                return view(state: &state, action: action)
            }
        }
        .ifLet(\.trending, action: \.trending) {
            CategoryPaginationFeature()
        }
        .forEach(\.path, action: \.path)
    }
    
    private func view(state: inout State, action: DiscoverFeature.View) -> Effect<Action> {
        switch action {
        case .performInitialFetchIfNeeded:
            return performInitialFetchIfNeeded(state: &state)
        case let .highlightedItemIndex(index):
            state.highlightedItemIndex = index
            return .none
        case let .seeAll(entertainmentCategory):
            state.path.append(.categoryPagination(CategoryPaginationFeature.State(entertainmentCategory: entertainmentCategory)))
            return .none
        case let .details(itemIdentifier):
            state.path.append(.details(DetailsFeature.State(itemIdentifier: itemIdentifier, entertainmentCategory: entertainmentCategory)))
            return .none
        case .binding(_):
            return .none
        }
    }
    
    private func performInitialFetchIfNeeded(state: inout State) -> Effect<Action> {
        guard state.sections.isEmpty else { return .none }
        let entertainmentCategory: EntertainmentCategory = self.entertainmentCategory.isMovieCategory ? .movies(.trending) : .tvShows(.trending)
        state.trending = CategoryPaginationFeature.State(entertainmentCategory: entertainmentCategory)
        return .run { send in
            do {
                let sections: [PaginationEntity]
                switch entertainmentCategory {
                case .movies: sections = try await discoverClient.fetchMovies()
                case .tvShows: sections = try await discoverClient.fetchTVShows()
                }
                await send(.sectionsResponse(sections))
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func path(state: inout State, action: StackActionOf<Path>) -> Effect<Action> {
        switch action {
        case let .element(id: _, action: .categoryPagination(.pagination(.view(.itemTapped(itemIdentifier))))):
            state.path.append(.details(DetailsFeature.State(itemIdentifier: itemIdentifier, entertainmentCategory: entertainmentCategory)))
        case let .element(id: _, action: .details(.view(.similarItemTapped(itemIdentifier)))):
            state.path.append(.details(DetailsFeature.State(itemIdentifier: itemIdentifier, entertainmentCategory: entertainmentCategory)))
        default: break
        }
        return .none
    }
  
    private func search(state: inout State, action: SearchFeature.Action) -> Effect<Action> {
        switch action {
        case let .pagination(.view(.itemTapped(itemIdentifier))):
            state.path.append(.details(DetailsFeature.State(itemIdentifier: itemIdentifier, entertainmentCategory: entertainmentCategory)))
        default: break
        }
        return .none
    }
    
    private func trending(state: inout State, action: CategoryPaginationFeature.Action) -> Effect<Action> {
        switch action {
        case let .pagination(.view(.itemTapped(itemIdentifier))):
            state.path.append(.details(DetailsFeature.State(itemIdentifier: itemIdentifier, entertainmentCategory: entertainmentCategory)))
        default: break
        }
        return .none
    }
}

extension DiscoverFeature {
    @Reducer(state: .equatable, action: .equatable)
    public enum Path {
        case categoryPagination(CategoryPaginationFeature)
        case details(DetailsFeature)
    }
}
