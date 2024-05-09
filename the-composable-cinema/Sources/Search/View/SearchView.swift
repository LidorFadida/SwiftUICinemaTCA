//
//  SearchView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import ComposableArchitecture
import SwiftUI
import Pagination

@ViewAction(for: SearchFeature.self)
public struct SearchView: View {
    @Bindable public var store: StoreOf<SearchFeature>
    private let searchButtonTopMargin: CGFloat
    
    public init(
        store: StoreOf<SearchFeature>,
        searchButtonTopMargin: CGFloat
    ) {
        self.store = store
        self.searchButtonTopMargin = searchButtonTopMargin
    }
    
    public var body: some View {
        ZStack {
            if store.isSearchActive {
                expandedSearchView
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .searchable(text: $store.searchQuery.sending(\.searchQueryChanged),
                                placement: .navigationBarDrawer(displayMode: .always))
                    .navigationTitle("Search")
            } else {
                collapsedSearchView
            }
        }
        .toolbar {
            if store.isSearchActive {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "xmark")
                        .symbolVariant(.circle.fill)
                        .foregroundStyle(.primary)
                        .frame(width: 36.0, height: 36.0)
                        .onTapGesture {
                            send(.toggleIsSearchActive,animation: .bouncy)
                        }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.automatic, for: .navigationBar)
        .toolbarRole(.editor)
    }
    
    private var collapsedSearchView: some View {
        GeometryReader { geometry in
            Button {
                send(.toggleIsSearchActive,animation: .bouncy)
            } label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .symbolVariant(.circle.fill)
                    .scaledToFit()
                    .frame(width: 36.0, height: 36.0)
            }
            .frame(width: 50, height: 50)
            .position(x: geometry.size.width - 32, y: (searchButtonTopMargin + 32.0))
        }
    }
    
    private var expandedSearchView: some View {
        VStack {
            if store.searchQuery.isEmpty {
                Image(systemName: "doc.text.magnifyingglass")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame([.horizontal, .vertical]) { value, axis in
                        return value * 0.3
                    }
                Text("Start typing to search")
                    .multilineTextAlignment(.center)
                    .font(.from(uiFont: .changaOne(32.0)))
                    .foregroundStyle(.primary)
                    .containerRelativeFrame(.horizontal) { value, axis in
                        return value * 0.8
                    }
            } else if let searchMessage = store.searchErrorMessage {
                Text(searchMessage)
                    .multilineTextAlignment(.center)
                    .font(.from(uiFont: .changaOne(24.0)))
                    .foregroundStyle(.primary)
                    .containerRelativeFrame(.horizontal) { value, axis in
                        return value * 0.8
                    }
                
                Spacer().frame(height: 6.0)
                
                Text("Please check your spelling or try searching for something else.")
                    .multilineTextAlignment(.center)
                    .font(.from(uiFont: .changaOne(24.0)))
                    .foregroundStyle(.primary)
                    .containerRelativeFrame(.horizontal) { value, axis in
                        return value * 0.8
                    }
            } else {
                DiscoverPaginationView(store: store.scope(state: \.pagination, action: \.pagination), shouldEmbedScrollView: true)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}
