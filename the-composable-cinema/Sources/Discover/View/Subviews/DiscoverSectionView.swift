//
//  DiscoverSectionView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI
import Entities

public struct DiscoverSectionView<Row: View, Footer: View>: View {
    @State private var activeIndex: Int? = nil
    private let paginationEntity: PaginationEntity
    private let rowForIndex: (Int) -> Row
    private let footer: () -> Footer?
    
    public init(
        paginationEntity: PaginationEntity,
        @ViewBuilder rowForIndex: @escaping (Int) -> Row,
        @ViewBuilder footer: @escaping () -> Footer?
    ) {
        self.paginationEntity = paginationEntity
        self.rowForIndex = rowForIndex
        self.footer = footer
    }
    
    public var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0.0) {
                    ForEach(Array(paginationEntity.items.enumerated()), id: \.element.id) { index, discoverItem in
                        rowForIndex(index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            
            footer()
        }
    }
}
