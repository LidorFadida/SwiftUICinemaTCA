//
//  DiscoverItemView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI
import SDWebImageSwiftUI
import Entities
import Resources

public struct DiscoverItemView: View {
    private let discoverItem: DiscoverItemEntity
    private let onTapGesture: (() -> Void)?
    
    public init(discoverItem: DiscoverItemEntity, onTapGesture: (() -> Void)? = nil) {
        self.discoverItem = discoverItem
        self.onTapGesture = onTapGesture
    }
    
    public var body: some View {
        ZStack {
            imageContentView
                .overlay(detailsOverlayView, alignment: .bottom)
                .contentShape(RoundedRectangle(cornerRadius: 8.0))
                .onTapGesture {
                    onTapGesture?()
                }
        }
    }
    
    private var imageContentView: some View {
        GeometryReader { proxy in
            WebImage(url: discoverItem.backdropPath) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .indicator(.activity)
            .transition(.fade)
            .scaledToFill()
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
    }
    
    private var detailsOverlayView: some View {
        ZStack {
            gradient
                .blur(radius: 5.0)
                .frame(maxWidth: .infinity, minHeight: 80.0, maxHeight: .infinity)
                .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: 0.0) {
                HStack(alignment: .bottom, spacing: 4.0) {
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.yellow)
                    Text(String(format: "%.1f", discoverItem.rating))
                        .font(.from(uiFont: .sfProDisplay(weight: .bold, 18.0)))
                        .foregroundStyle(Color.primary)
                }
                .frame(height: 24.0)
                
                Text(discoverItem.title)
                    .font(.from(uiFont: .sfProDisplay(weight: .heavy, 18.0)))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.primary)
            }
            .frame(height: 80.0)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
    }
    
    private var gradient: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [.init(uiColor: .systemBackground).opacity(0.4),
                                                   .init(uiColor: .systemBackground).opacity(0.4),
                                                   .init(uiColor: .systemBackground).opacity(0.4),
                                                   .init(uiColor: .systemBackground).opacity(0.0)]),
                       startPoint: .bottomLeading,
                       endPoint: .topTrailing)
    }
}
