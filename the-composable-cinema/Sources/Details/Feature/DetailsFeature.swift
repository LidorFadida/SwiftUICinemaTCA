//
//  DetailsFeature.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//


import ComposableArchitecture
import TMDBCore
import Entities

@Reducer
public struct DetailsFeature {
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var itemIdentifier: Int
        public var entertainmentCategory: EntertainmentCategory
        public var itemDetails: DetailsEntity?
        
        public init(
            itemIdentifier: Int,
            entertainmentCategory: EntertainmentCategory,
            itemDetails: DetailsEntity? = nil
        ) {
            self.itemIdentifier = itemIdentifier
            self.entertainmentCategory = entertainmentCategory
            self.itemDetails = itemDetails
        }
    }
    
    public enum Action: Equatable, ViewAction {
        case itemDetailsResponse(DetailsEntity)
        case view(View)
    }
    
    @CasePathable
    public enum View: BindableAction, Sendable, Equatable {
        case binding(BindingAction<State>)
        case fetchItemDetails
        case similarItemTapped(Int)
    }
    
    @Dependency(\.detailsClient) var detailsClient
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .view(action):
                return view(state: &state, action: action)
            case let .itemDetailsResponse(response):
                state.itemDetails = response
                return .none
            }
        }
    }
    
    private func view(state: inout State, action: DetailsFeature.View) -> Effect<Action> {
        switch action {
        case .fetchItemDetails:
            guard state.itemDetails == nil else { return .none }
            
            return .run { [itemIdentifier = state.itemIdentifier, entertainmentCategory = state.entertainmentCategory] send in
                do {
                    let detailsEntity = try await detailsClient.fetchDetails(itemIdentifier,
                                                                             entertainmentCategory)
                    await send(.itemDetailsResponse(detailsEntity))
                } catch {
                    assertionFailure(error.localizedDescription)
                }
            }
        case .similarItemTapped(_):
            return .none
        case .binding:
            return .none
        }
    }
}
