//
//  DiscoverView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI
import ComposableArchitecture
import Entities
import Pagination
import Search
import Details
import Common

@ViewAction(for: DiscoverFeature.self)
public struct DiscoverView: View {
    @Bindable public var store: StoreOf<DiscoverFeature>
    
    private var isItemCentered: (Int, GeometryProxy) -> Int? = { index, geometry in
        let frame = geometry.frame(in: .global)
        let midX = frame.midX
        let midScreen = UIScreen.main.bounds.width / 2
        return abs(midX - midScreen) < 150 ? index : nil
    }
    
    public init(store: StoreOf<DiscoverFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 20.0, pinnedViews: [.sectionHeaders]) {
                        ForEach(Array(store.sections.enumerated()), id: \.element.id) { index, paginationEntity in
                            Section(header: headerView(title: paginationEntity.title, action: {
                                send(.seeAll(paginationEntity.entertainmentCategory))
                            })) {
                                makeSection(paginationEntity: paginationEntity, section: index)
                                    .frame(height: index == 0 ? UIScreen.main.bounds.height * 0.6 : 460.0)
                            }
                        }
                    }
                    if let trendingPagination = store.scope(state: \.trending, action: \.trending) {
                        DiscoverPaginationView(
                            store: trendingPagination.scope(state: \.pagination, action: \.pagination),
                            shouldEmbedScrollView: false) {
                                headerView(title: trendingPagination.entertainmentCategory.title) {
                                    send(.seeAll(trendingPagination.entertainmentCategory))
                                }
                            }
                    }
                }
                .padding(.top, 1.0)
                SearchView(store: store.scope(state: \.search, action: \.search), searchButtonTopMargin: 60.0)
                    
            }
        } destination: { store in
            switch store.case {
            case .categoryPagination(let store):
                DiscoverPaginationView(store: store.scope(state: \.pagination, action: \.pagination),
                                              shouldEmbedScrollView: true)
                .navigationTitle(store.entertainmentCategory.title)
            case .details(let store):
                DetailsView(store: store)
            }
        }
        .task {
            send(.performInitialFetchIfNeeded)
        }
        .tint(.white)
    }
    
    private func makeSection(paginationEntity: PaginationEntity, section: Int) -> some View {
        let isFirstSection = (section == 0)
        return DiscoverSectionView(paginationEntity: paginationEntity) { index in
            let discoverItem = paginationEntity.items[index]
            if isFirstSection {
                makeDiscoverHighlightedView(discoverItem: discoverItem, index: index)
                    .containerRelativeFrame(.horizontal)
            } else {
                makeDiscoverItemView(discoverItem: discoverItem)
                    .padding(.horizontal, 12.0)
            }
        } footer: {
            let itemsCount = paginationEntity.items.count
            if isFirstSection {
                footer(itemsCount: itemsCount)
            } else {
                EmptyView()
            }
        }
    }
    
    private func headerView(title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.from(uiFont: .sfProDisplay(weight: .bold, 18.0)))
                .foregroundStyle(.primary)
            Spacer()
            Button {
                action()
            } label: {
                HStack {
                    Text("See All")
                        .font(.from(uiFont: .sfProDisplay(weight: .bold, 18.0)))
                        .foregroundStyle(.primary)
                    Image(systemName: "chevron.right")
                        .aspectRatio(contentMode: .fit)
                        .bold()
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 12.0)
        .frame(maxWidth: .infinity)
        .frame(height: 60.0)
        .background(.background)
        
    }
    
    private func makeDiscoverItemView(discoverItem: DiscoverItemEntity) -> some View {
        DiscoverItemView(discoverItem: discoverItem) {
            send(.details(discoverItem.itemIdentifier))
        }
        .frame(width: 300.0)
        .frame(maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .padding(.vertical)
        .padding(.leading, 4.0)
        .shadow(color: .primary, radius: 2.0)
    }
    
    private func makeDiscoverHighlightedView(discoverItem: DiscoverItemEntity, index: Int) -> some View {
        DiscoverHighlightedView(discoverItem: discoverItem)
            .background(
                GeometryReader { geoReader in
                    Color.clear.preference(key: CenteredItemKey.self, value: isItemCentered(index, geoReader))
                }
            )
            .onTapGesture {
                send(.details(discoverItem.itemIdentifier))
            }
            .onPreferenceChange(CenteredItemKey.self) { value in
                send(.highlightedItemIndex(value), animation: .spring)
            }
    }
    
    private func footer(itemsCount: Int) -> some View {
        GeometryReader { proxy in
            HStack(spacing: 0.0) {
                ForEach((0..<itemsCount), id: \.self) { index in
                    if (index == 0) || (index == itemsCount - 1) {
                        let isFirst = (index == 0)
                        let isLast = (index == itemsCount - 1)
                        let targetRadius: CGFloat = 3.0
                        UnevenRoundedRectangle(topLeadingRadius: isFirst ? targetRadius : .zero,
                                               bottomLeadingRadius: isFirst ? targetRadius : .zero,
                                               bottomTrailingRadius: isLast ? targetRadius : .zero,
                                               topTrailingRadius: isLast ? targetRadius : .zero)
                        .fill(index == store.highlightedItemIndex ? .primary : .secondary)
                        .frame(width: proxy.size.width / CGFloat(itemsCount), height: 6.0)
                    } else {
                        Rectangle()
                            .fill(index == store.highlightedItemIndex ? .primary : .secondary)
                            .frame(width: proxy.size.width / CGFloat(itemsCount), height: 6.0)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 24.0)
    }
}
