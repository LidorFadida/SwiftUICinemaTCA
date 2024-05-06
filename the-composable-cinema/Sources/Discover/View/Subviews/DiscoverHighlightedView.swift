//
//  HighlightedCarouselView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Entities
import Common

public struct DiscoverHighlightedView: View {
    private let discoverItem: DiscoverItemEntity
    
    public init(discoverItem: DiscoverItemEntity) {
        self.discoverItem = discoverItem
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Spacer()
                backgroundImage
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                HStack(alignment: .center) {
                    GeometryReader { proxy in
                        HStack(alignment: .top) {
                            
                            WebImage(url: discoverItem.posterPath) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .indicator(.activity)
                            .transition(.fade)
                            .scaledToFill()
                            .frame(width: proxy.size.width * 0.3, height: proxy.size.height * 1.2)
                            .clipShape(RoundedRectangle(cornerRadius: 6.0))
                            .shadow(color: .primary.opacity(0.5), radius: 12.0)
                            .padding(.leading, 12.0)
                            .offset(y: -proxy.size.height * 0.3)
                            
                            detailsView
                                .frame(height: proxy.size.height * 1.0 , alignment: .top)
                                .padding(.top, 6.0)
                            Color.clear
                                .frame(minWidth: 24.0)
                                .layoutPriority(-1)
                        }
                    }
                }
                .frame(width: proxy.size.width, height: proxy.size.height * 0.3)
                .background(alignment: .center) {
                    Rectangle()
                        .background(.ultraThinMaterial)
                }
            }
        }
    }
    
    private var backgroundImage: some View {
        WebImage(url: discoverItem.backdropPath) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .indicator(.activity)
        .transition(.fade)
        .scaledToFill()
    }
    
    private var detailsView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text(discoverItem.title)
                .minimumScaleFactor(0.3)
                .font(.from(uiFont: .changaOne(24.0)))
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .kerning(1.2)
                .foregroundStyle(.white)
            HStack(spacing: 12.0) {
                HStack(alignment: .center, spacing: 4.0) {
                    Image(systemName: "calendar.badge.plus")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.white)
                    Text(discoverItem.releaseDate)
                        .font(.from(uiFont: .sfProDisplay(weight: .bold, 16.0)))
                        .foregroundStyle(.white)
                }
            }
            HStack(alignment: .center, spacing: 4.0) {
                StarRatingView(rating: discoverItem.rating / 2, maxRating: 5)
                    .fixedSize()
                Text(String(format: "%.1f", discoverItem.rating))
                    .font(.from(uiFont: .sfProDisplay(weight: .heavy, 18.0)))
                    .foregroundStyle(.white)
            }
            .frame(height: 18.0)
        }
    }
}
