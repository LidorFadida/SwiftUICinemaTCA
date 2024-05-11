//
//  RootFeature.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 03/05/2024.
//

import ComposableArchitecture
import Network
import Discover
import Resources
import TMDBCore

@Reducer
public struct AppFeature {
    
    public init(apiKey: String? = nil) {
        Resources.configure()
        guard let apiKey else { return }
        TMDBNetwork.shared.configure(apiKey: apiKey, logLevel: .info)
    }
    
    @ObservableState
    public struct State: Equatable {
        var moviesTab: DiscoverFeature.State
        var tvShowsTab: DiscoverFeature.State
        
        public init(
            moviesTab: DiscoverFeature.State = DiscoverFeature.State(),
            tvShowsTab: DiscoverFeature.State = DiscoverFeature.State()
        ) {
            self.moviesTab = moviesTab
            self.tvShowsTab = tvShowsTab
        }
    }
    
    public enum Action {
        case moviesTab(DiscoverFeature.Action)
        case tvShowsTab(DiscoverFeature.Action)
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.moviesTab, action: \.moviesTab) {
            ///'.nowPlaying' is ignored in 'DiscoverMoviesFeature'
            DiscoverFeature(entertainmentCategory: .movies(.nowPlaying))
        }
        
        Scope(state: \.tvShowsTab, action: \.tvShowsTab) {
            ///'.onTheAir' is ignored in 'DiscoverMoviesFeature'
            DiscoverFeature(entertainmentCategory: .tvShows(.onTheAir))
        }
        Reduce { state, action in return .none }
    }
}
