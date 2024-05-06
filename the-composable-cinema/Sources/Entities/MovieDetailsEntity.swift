//
//  MovieDetailsEntity.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Foundation
import Network
import Dependencies
import TMDBCore

public struct DetailsEntity: Equatable {
    public let title: String
    public let rating: Double
    public let date: String
    public let backdropPath: URL?
    public let overview: String
    public let genres: [String]
    public let runtime: Int
    public let cast: [CastEntity]
    public let similar: [DiscoverItemEntity]
    
    public init(
        title: String,
        rating: Double,
        date: String,
        backdropPath: URL?,
        overview: String,
        genres: [String],
        runtime: Int,
        cast: [CastEntity],
        similar: [DiscoverItemEntity]
    ) {
        self.title = title
        self.rating = rating
        self.date = date
        self.backdropPath = backdropPath
        self.overview = overview
        self.genres = genres
        self.runtime = runtime
        self.cast = cast
        self.similar = similar
    }
    
    public init(itemDetailsResponse: any TMDBItemDetailsResponseProtocol) {
        @Dependency(\.uuid) var uuid
        let imageLargeSizeURLPath = TMDBCoreProperties.Constants.imageLargeSizeURLPath
        let imageSmallSizeURLPath = TMDBCoreProperties.Constants.imageSmallSizeURLPath
        var backdropPath: URL? = nil
        if let backdrop = itemDetailsResponse.backdropPath {
            backdropPath = URL(string: imageLargeSizeURLPath + backdrop)
        }
        let releaseDate = DateFormatter.convertDateString(itemDetailsResponse.releaseDate)
        let genres = itemDetailsResponse.genres.compactMap { $0.name }
        let overview = itemDetailsResponse.overview ?? "Unavailable atm"
        let cast = itemDetailsResponse.credits.cast.compactMap { castResponse in
            var url: URL?
            if let profilePath = castResponse.profilePath {
                url = URL(string: imageSmallSizeURLPath + profilePath)
            }
            return CastEntity(id: uuid().uuidString,profileURL: url, name: castResponse.name, characterName: castResponse.character ?? "")
        }
        
        self.title = itemDetailsResponse.title
        self.rating = itemDetailsResponse.voteAverage
        self.date = releaseDate
        self.backdropPath = backdropPath
        self.overview = overview
        self.genres = genres
        self.runtime = itemDetailsResponse.runtime
        self.cast = cast
        let discoverItemEntities = itemDetailsResponse.similar.results.compactMap { itemResponse in
            return DiscoverItemEntity(id: uuid().uuidString, response: itemResponse)
        }
        self.similar = discoverItemEntities
    }
}
