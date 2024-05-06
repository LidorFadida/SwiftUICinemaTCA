//
//  StarRatingView.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import SwiftUI

public struct StarRatingView: View {
    
    private struct ClipShape: Shape {
        let width: Double
        
        func path(in rect: CGRect) -> Path {
            Path(CGRect(x: .zero, y: .zero, width: width, height: rect.height))
        }
    }
    
    private let rating: Double
    private let maxRating: Int
    
    public init(rating: Double, maxRating: Int) {
        self.maxRating = maxRating
        self.rating = rating
    }
    
    public var body: some View {
        HStack(spacing: 0.0) {
            ForEach(0..<maxRating, id: \.self) { _ in ///Draws maxRating times outlined star
                Text(Image(systemName: "star"))
                    .foregroundColor(.yellow)
                    .aspectRatio(contentMode: .fill)
            }
        }.overlay(
            GeometryReader { reader in
                HStack(spacing: 0.0) {
                    ForEach(0..<maxRating, id: \.self) { _ in ///Draws maxRating times filled star
                        Image(systemName: "star.fill")
                            .symbolEffect(.scale, options: .nonRepeating)
                            .foregroundColor(.yellow)
                            .aspectRatio(contentMode: .fit)
                    }
                }
                .clipShape(///Clips the filled stars rectangle by width / maxRating * rating.
                    ClipShape(width: (reader.size.width / CGFloat(maxRating)) * CGFloat(rating))
                )
            }
        )
    }
}
