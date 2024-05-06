//
//  DetailsView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import ComposableArchitecture
import Entities
import Resources
import Common

@ViewAction(for: DetailsFeature.self)
public struct DetailsView: View {
    public let store: StoreOf<DetailsFeature>
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [.init(uiColor: .systemBackground).opacity(1.0),
                                                   .init(uiColor: .systemBackground).opacity(0.8),
                                                   .init(uiColor: .systemBackground).opacity(0.8),
                                                   .init(uiColor: .systemBackground).opacity(0.0)]),
                       startPoint: .bottom,
                       endPoint: .top)
    }
    
    public init(store: StoreOf<DetailsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if let itemDetails = store.itemDetails {
                contentView(itemDetails: itemDetails)
            } else {
                ProgressView()
                    .controlSize(.extraLarge)
            }
        }
        
        .ignoresSafeArea(.container, edges: .top)
        ///produces navigation swipe to dismiss gesture bug. (navigationBar disappear completely)
        ///so unfortunately when scrolling the bar will be visible.
//        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarRole(.editor)
        .task {
            send(.fetchItemDetails)
        }
    }
    
    private func contentView(itemDetails: DetailsEntity) -> some View {
        ScrollView {
            VStack(spacing: 12.0) {
                introView(imageURL: itemDetails.backdropPath,
                          overview: itemDetails.overview,
                          title: itemDetails.title,
                          runtime: itemDetails.runtime,
                          date: itemDetails.date,
                          rating: itemDetails.rating)
                
                ExpandableText(itemDetails.overview, lineLimit: 4, font: .sfProDisplay(weight: .medium, 16.0))
                    .padding(.horizontal)
                
                genresView(genres: itemDetails.genres)
                    .padding(.horizontal)
                if !itemDetails.cast.isEmpty {
                    castView(cast: itemDetails.cast)
                        .padding(.vertical)
                }
                if !itemDetails.similar.isEmpty {
                    similarItemsView(discoverItems: itemDetails.similar)
                        .frame(maxWidth: .infinity)
                        .frame(height: 400.0)
                }
            }
        }
        .scrollIndicators(.never)
    }

    private func introView(imageURL: URL?,
                           overview: String,
                           title: String,
                           runtime: Int,
                           date: String,
                           rating: Double) -> some View {
            WebImage(url: imageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .indicator(.activity)
            .transition(.fade)
            .scaledToFill()
            .frame(maxWidth: UIScreen.main.bounds.width)
            .frame(height: 560.0)
            .clipped()
            .overlay(detailsOverlayView(title: title, runtime: runtime, date: date, rating: rating), alignment: .bottom)
        
    }
    
    private func detailsOverlayView(title: String,
                                    runtime: Int,
                                    date: String,
                                    rating: Double) -> some View {
        headerView(title: title, runtime: runtime, date: date, rating: rating)
            .padding(.horizontal)
            .padding(.bottom, 6.0)
            .frame(maxWidth: .infinity)
            .background(
                gradient.blur(radius: 5.0).scaleEffect(CGSize(width: 2.0, height: 2.0))
            )
            .fixedSize(horizontal: false, vertical: false)
    }
    
    private func headerView(title: String,
                            runtime: Int,
                            date: String,
                            rating: Double) -> some View {
        ///Header
        VStack(alignment: .leading, spacing: 8.0) {
            Text(title)
                .font(.from(uiFont: .changaOne(28.0)))
                .foregroundStyle(.primary)
            HStack(spacing: 18.0) {
                HStack(alignment: .center, spacing: 4.0) {
                    Image(systemName: "clock")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.secondary)
                        .bold()
                    Text("\(runtime.formattedDuration())")
                        .font(.from(uiFont: .changaOne(16.0)))
                        .foregroundStyle(.secondary)
                }
                HStack(alignment: .center, spacing: 4.0) {
                    Image(systemName: "calendar.badge.plus")
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.secondary)
                        .bold()
                    Text(date)
                        .font(.from(uiFont: .changaOne(16.0)))
                        .foregroundStyle(.secondary)
                }
            }
            
            HStack(alignment: .bottom, spacing: 4.0) {
                StarRatingView(rating: (rating / 2.0), maxRating: 5)
                Text(String(format: "%.1f", rating))
                    .font(.from(uiFont: .sfProDisplay(weight: .heavy, 18.0)))
                    .foregroundStyle(Color.primary)
            }
            .frame(height: 18.0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func genresView(genres: [String]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .font(.from(uiFont: .changaOne(18.0)))
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .padding(.horizontal, 8.0)
                        .padding(.vertical, 4.0)
                        .background(Color.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 6.0))
                }
            }
            .padding(.vertical, 6.0)
        }
    }
    
    private func castView(cast: [CastEntity]) -> some View {
        VStack {
            Text("Cast")
                .multilineTextAlignment(.leading)
                .font(.from(uiFont: .sfProDisplay(weight: .bold, 24.0)))
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12.0) {
                    ForEach(cast) { castItem in
                       castItemView(castEntity: castItem)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
    
    private func castItemView(castEntity: CastEntity) -> some View {
        VStack {
            castProfileImage(url: castEntity.profileURL)
                .frame(width: 185.0, height: 278.0)
            VStack(alignment: .leading, spacing: 2) {
                Text(castEntity.name)
                    .font(.from(uiFont: .sfProDisplay(weight: .medium, 14.0)))
                    .lineLimit(2)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(castEntity.characterName)
                    .font(.from(uiFont: .sfProDisplay(weight: .medium, 12.0)))
                    .lineLimit(2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 6.0)
            .padding(.bottom, 6.0)
        }
        .background(.background)
        .overlay(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(.primary, lineWidth: 2.0)
        )
        .padding(.vertical, 8.0)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .shadow(color: .primary, radius: 3.0)
    }
    
    @ViewBuilder
    private func castProfileImage(url: URL?) -> some View {
        if let profileImageURL = url {
            WebImage(url: profileImageURL) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .indicator(.activity)
            .transition(.fade)
            .scaledToFill()
            .clipped()
        } else {
            VStack {
                Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
                    .resizable()
                    .containerRelativeFrame([.horizontal, .vertical]) { value, axis in
                        return value * 0.3
                    }
                Text("Unavailable")
                    .font(.from(uiFont: .sfProDisplay(weight: .medium, 16.0)))
            }
        }
    }
        
    private func similarItemsView(discoverItems: [DiscoverItemEntity]) -> some View {
        VStack(spacing: .zero) {
            Text("Similar \(store.entertainmentCategory.description)")
                .multilineTextAlignment(.leading)
                .font(.from(uiFont: .sfProDisplay(weight: .bold, 24.0)))
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12.0) {
                    ForEach(discoverItems, id: \.id) { item in
                        DiscoverItemView(discoverItem: item) {
                            send(.similarItemTapped(item.itemIdentifier))
                        }
                        .containerRelativeFrame([.horizontal, .vertical]) { value, axis in
                            switch axis {
                            case .horizontal: return value * 0.6
                            case .vertical: return value * 0.9
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8.0))
                        .shadow(color: .primary, radius: 2.0)
                        .contentShape(RoundedRectangle(cornerRadius: 8.0))
                    }
                }
                .padding(.horizontal, 6.0)
                .scrollTargetLayout()
            }
            .padding(.top, 1.0)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    DetailsView(store: Store(initialState: DetailsFeature.State(itemIdentifier: 87, entertainmentCategory: .movies(.nowPlaying)), reducer: {
        DetailsFeature()
    }))
}
