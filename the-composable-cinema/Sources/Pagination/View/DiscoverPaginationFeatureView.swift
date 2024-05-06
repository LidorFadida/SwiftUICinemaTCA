//
//  DiscoverPaginationView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import SwiftUI
import ComposableArchitecture
import Entities
import Common

@ViewAction(for: PaginationFeature<DiscoverItemEntity>.self)
public struct DiscoverPaginationView<Header>: View where Header: View {
    public let store: StoreOf<PaginationFeature<DiscoverItemEntity>>
    let shouldEmbedScrollView: Bool
    let header: () -> Header?
    
    public init(
        store: StoreOf<PaginationFeature<DiscoverItemEntity>>,
        shouldEmbedScrollView: Bool = true,
        @ViewBuilder header: @escaping () -> Header? = { EmptyView() }
    ) {
        self.store = store
        self.shouldEmbedScrollView = shouldEmbedScrollView
        self.header = header
    }
    
    public var body: some View {
        VStack {
            if shouldEmbedScrollView {
                ScrollView(.vertical) {
                    paginationLazyGrid
                }
            } else {
                paginationLazyGrid
            }
        }
        .padding(.top, 1.0)
        .task {
            send(.fetchInitialPage)
        }
    }
    
    private var paginationLazyGrid: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], pinnedViews: [.sectionHeaders]) {
                Section(header: header()) {
                    ForEach(store.items) { item in
                        DiscoverItemView(discoverItem: item) {
                            send(.itemTapped(item.itemIdentifier))
                        }
                        .frame(height: 270.0)
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        .padding(8.0)
                        .shadow(color: .primary, radius: 2.0)
                        .contentShape(RoundedRectangle(cornerRadius: 8.0))
                        .onAppear {
                            if item == store.items.last {
                                send(.reachedLastItem)
                            }
                        }
                    }
                }
            }
            .padding()
            if store.isLoading {
                ProgressView()
                    .controlSize(.extraLarge)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

