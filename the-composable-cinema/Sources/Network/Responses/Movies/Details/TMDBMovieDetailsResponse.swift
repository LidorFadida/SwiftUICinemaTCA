//
//  TMDBMovieDetailsResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public struct TMDBMovieDetailsResponse: TMDBItemDetailsResponseProtocol {
    public let title: String
    public let voteAverage: Double
    public let releaseDate: String
    public let backdropPath: String?
    public let overview: String?
    public let genres: [GenreResponse]
    public let runtime: Int
    public let credits: CreditsResponse
    public let similar: any TMDBPageResponseProtocol
    
    enum CodingKeys: String, CodingKey {
        case title
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case overview
        case genres
        case runtime
        case credits
        case similar
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.genres = try container.decode([GenreResponse].self, forKey: .genres)
        self.runtime = try container.decode(Int.self, forKey: .runtime)
        self.credits = try container.decode(CreditsResponse.self, forKey: .credits)
        
        let similar = try container.decode(TMDBMoviesPageResponse.self, forKey: .similar)
        self.similar = similar as any TMDBPageResponseProtocol
    }
}
