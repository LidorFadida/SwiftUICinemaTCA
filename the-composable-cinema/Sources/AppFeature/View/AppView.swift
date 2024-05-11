//
//  RootView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 03/05/2024.
//

import SwiftUI
import ComposableArchitecture
import Discover

public struct AppView: View {
    let store: StoreOf<AppFeature>
    
    public init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    public var body: some View {
        TabView {
            DiscoverView(store: store.scope(state: \.moviesTab, action: \.moviesTab))
                .tabItem {
                    Image(systemName: "film")
                    Text("Movies")
                }
            
            DiscoverView(store: store.scope(state: \.tvShowsTab, action: \.tvShowsTab))
                .tabItem {
                    Image(systemName: "tv.circle")
                    Text("TV Shows")
                }
        }
    }
}

#Preview {
    AppView(store: Store(initialState: AppFeature.State(), reducer: { AppFeature() }))
}
