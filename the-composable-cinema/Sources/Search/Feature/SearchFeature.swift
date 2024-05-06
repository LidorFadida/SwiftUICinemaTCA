//
//  SearchFeature.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import ComposableArchitecture
import Network
import TMDBCore
import Pagination
import Entities

@Reducer
public struct SearchFeature {
    public let entertainmentCategory: EntertainmentCategory
    
    public init(entertainmentCategory: EntertainmentCategory) {
        switch entertainmentCategory {
        case .movies(_): self.entertainmentCategory = .movies(.search)
        case .tvShows(_): self.entertainmentCategory = .tvShows(.search)
        }
    }
    
    @ObservableState
    public struct State: Equatable {
        public var debounceInterval: Duration
        public var isSearchActive = false
        public var searchQuery: String
        public var searchErrorMessage: String?
        public var pagination: PaginationFeature<DiscoverItemEntity>.State
        
        public init(
            debounceInterval: Duration = .milliseconds(400.0),
            isSearchActive: Bool = false,
            searchQuery: String = "",
            searchErrorMessage: String? = nil,
            pagination: PaginationFeature<DiscoverItemEntity>.State
        ) {
            self.debounceInterval = debounceInterval
            self.isSearchActive = isSearchActive
            self.searchQuery = searchQuery
            self.searchErrorMessage = searchErrorMessage
            self.pagination = pagination
        }
    }
    
    public enum Action: Equatable, ViewAction {
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case pagination(PaginationFeature<DiscoverItemEntity>.Action)
        case pageResponse(PaginationEntity)
        case reset
        case view(View)
    }
    
    @CasePathable
    public enum View: BindableAction, Sendable, Equatable {
        case binding(BindingAction<State>)
        case toggleIsSearchActive
    }
    
    private enum CancelID {
        case searchQuery
    }
    
    @Dependency(\.searchClient) var searchClient
    @Dependency(\.continuousClock) var clock
        
    public var body: some ReducerOf<Self> {
        Scope(state: \.pagination, action: \.pagination) {
            PaginationFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .searchQueryChanged(query):
                return searchQueryChanged(state: &state, query: query)
            case .searchQueryChangeDebounced:
                return searchQueryChangeDebounced(state: &state)
            case let .pagination(action):
                return pagination(state: &state, action: action)
            case let .pageResponse(paginationEntity):
                return pageResponse(state: &state, paginationEntity: paginationEntity)
            case .reset:
                return reset(state: &state)
            case let .view(action):
                return view(state: &state, action: action)
            }
        }
    }
    
    private func view(state: inout State, action: SearchFeature.View) -> Effect<Action> {
        switch action {
        case .toggleIsSearchActive:
            state.isSearchActive.toggle()
            return .none
        default:
            return .none
        }
    }
    
    private func searchQueryChanged(state: inout State, query: String) -> Effect<Action> {
        state.searchErrorMessage = nil
        state.searchQuery = query
        return .cancel(id: CancelID.searchQuery)
            .concatenate(
                with: .run { send in
                    await send(.reset)
                }
            ).concatenate(
                with: .run { [state = state] send in
                    do {
                        try await clock.sleep(for: state.debounceInterval)
                        await send(.searchQueryChangeDebounced)
                    } catch { }
                }
            )
    }
    
    private func searchQueryChangeDebounced(state: inout State) -> Effect<Action> {
        guard state.pagination.totalPages == 0 else { return .none }
        guard !state.searchQuery.isEmpty else { return .cancel(id: CancelID.searchQuery) }
        return .run { [searchQuery = state.searchQuery] send in
            do {
                guard let paginationEntity = try await searchClient.fetchPage(searchQuery, 1, entertainmentCategory) else { return }
                await send(.pageResponse(paginationEntity))
            } catch { assertionFailure(error.localizedDescription) }
        }
        .cancellable(id: CancelID.searchQuery, cancelInFlight: true)
    }
    
    private func pagination(state: inout State, action: PaginationFeature<DiscoverItemEntity>.Action) -> Effect<Action> {
        switch action {
        case let .fetchNextPage(page):
            return fetchNextPage(searchQuery: state.searchQuery, page: page)
        default: return .none
        }
    }
    
    private func fetchNextPage(searchQuery: String, page: Int) -> Effect<Action> {
        return .run { send in
            do {
                guard let paginationEntity = try await searchClient.fetchPage(searchQuery, page, entertainmentCategory) else { return }
                await send(.pageResponse(paginationEntity))
            } catch { assertionFailure(error.localizedDescription) }
        }
    }
    
    private func pageResponse(state: inout State, paginationEntity: PaginationEntity) -> Effect<Action> {
        if paginationEntity.items.isEmpty {
            state.searchErrorMessage = "We couldn't find any results for\n'\(state.searchQuery)'\n"
        }
        return PaginationFeature<DiscoverItemEntity>()
            .body
            .reduce(into: &state.pagination, action: .receivedPage(paginationEntity.page, paginationEntity.totalPages, paginationEntity.items))
            .map(Action.pagination)
    }
    
    private func reset(state: inout State) -> Effect<Action> {
        return PaginationFeature<DiscoverItemEntity>()
            .body
            .reduce(into: &state.pagination, action: .reset)
            .map(Action.pagination)
    }
}
