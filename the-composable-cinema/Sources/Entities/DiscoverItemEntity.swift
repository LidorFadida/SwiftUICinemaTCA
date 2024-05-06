//
//  DiscoverItemEntity.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Foundation
import Network
import TMDBCore

public struct DiscoverItemEntity: Equatable, Identifiable {
    public let id: String
    public let itemIdentifier: Int
    public let title: String
    public let rating: Double
    public let releaseDate: String
    public let backdropPath: URL?
    public let posterPath: URL?
    
    public init(
        id: String,
        itemIdentifier: Int,
        title: String,
        rating: Double,
        releaseDate: String,
        backdropPath: URL?,
        posterPath: URL?
    ) {
        self.id = id
        self.itemIdentifier = itemIdentifier
        self.title = title
        self.rating = rating
        self.releaseDate = releaseDate
        self.backdropPath = backdropPath
        self.posterPath = posterPath
    }
    
    public init(id: String, response: any TMDBItemResponseProtocol) {
        self.id = id
        self.itemIdentifier = response.id
        self.title = response.title
        self.rating = response.voteAverage
        self.releaseDate = DateFormatter.convertDateString(response.releaseDate)
        
        
        let imageLargeSizeURLPath = TMDBCoreProperties.Constants.imageLargeSizeURLPath
        let imageMediumSizeURLPath = TMDBCoreProperties.Constants.imageMediumSizeURLPath
        
        var backdropPath: URL? = nil
        if let backdrop = response.backdropPath {
            backdropPath = URL(string: imageLargeSizeURLPath + backdrop)
        }
        self.backdropPath = backdropPath
        var posterPath: URL?
        if let poster = response.posterPath {
            posterPath = URL(string: imageMediumSizeURLPath + poster)
        }
        self.posterPath = posterPath
    }
}
