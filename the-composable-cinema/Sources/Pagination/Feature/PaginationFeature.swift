//
//  PaginationFeature.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import ComposableArchitecture

@Reducer
public struct PaginationFeature<T: Equatable & Identifiable> {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var page: Int
        public var totalPages: Int
        public var items: [T]
        public var isLoading: Bool
        
        public init(
            page: Int = 1,
            totalPages: Int = 0,
            items: [T] = [],
            isLoading: Bool = false
        ) {
            self.page = page
            self.totalPages = totalPages
            self.items = items
            self.isLoading = isLoading
        }
    }
    
    public enum Action: Equatable, ViewAction {
        case fetchNextPage(Int)
        case receivedPage(Int, Int, [T])
        case reachedTotalPages
        case reset
        case view(View)
    }
    
    @CasePathable
    public enum View: BindableAction, Sendable, Equatable {
        case binding(BindingAction<State>)
        case fetchInitialPage
        case itemTapped(Int)
        case reachedLastItem
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchNextPage:
                return .none
            case let .receivedPage(page, totalPages, items):
                return receivedPage(state: &state, page: page, totalPages: totalPages, items: items)
            case .reachedTotalPages:
                state.isLoading = false
                return .none
            case .reset:
                return resetState(state: &state)
            case let .view(action):
                return view(state: &state, action: action)
            }
        }
    }
    
    private func view(state: inout State, action: PaginationFeature.View) -> Effect<Action> {
        switch action {
        case .binding(_): return .none
        case .fetchInitialPage:
            state.isLoading = true
            return .none
        case .itemTapped:
            return .none
        case .reachedLastItem:
            return reachedLastItem(state: &state)
        }
    }
    
    private func receivedPage(state: inout State, page: Int, totalPages: Int, items: [T]) -> Effect<Action> {
        state.isLoading = false
        state.page = page
        state.totalPages = totalPages
        state.items.append(contentsOf: items)
        guard page < totalPages else { return .run { send in await send(.reachedTotalPages) } }
        return .none
    }
    
    private func reachedLastItem(state: inout State) -> Effect<Action> {
        state.isLoading = true
        return .run { [page = state.page, totalPages = state.totalPages] send in
            guard page < totalPages else { return await send(.reachedTotalPages) }
            let page = (page + 1)
            await send(.fetchNextPage(page))
        }
    }
    
    private func resetState(state: inout State) -> Effect<Action> {
        state.isLoading = false
        state.page = 1
        state.totalPages = 0
        state.items = []
        return .none
    }
}
