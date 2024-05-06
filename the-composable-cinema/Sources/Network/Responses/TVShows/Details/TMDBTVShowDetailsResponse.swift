//
//  TMDBTVShowDetailsResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

struct TMDBTVShowDetailsResponse: TMDBItemDetailsResponseProtocol {
    let title: String
    let voteAverage: Double
    let releaseDate: String
    let backdropPath: String?
    let overview: String?
    let genres: [GenreResponse]
    let runtime: Int
    let credits: CreditsResponse
    let similar: any TMDBPageResponseProtocol
    
    enum CodingKeys: String, CodingKey {
        case title = "name"
        case voteAverage = "vote_average"
        case releaseDate = "first_air_date"
        case backdropPath = "backdrop_path"
        case overview
        case genres
        case runtime = "episode_run_time"
        case credits
        case similar
    }
    
    ///TV shows JSON structure is different so init(from:) throws is implemented to conform 'TMDBItemDetailsResponse'.
    ///
    ///Doing so reduce the complexity in the UI layer. (The reason is the 'duration' value that is nested within array)
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.genres = try container.decode([GenreResponse].self, forKey: .genres)
        var runtimeContainer = try container.nestedUnkeyedContainer(forKey: .runtime)
        self.runtime = try runtimeContainer.decodeIfPresent(Int.self) ?? 0  /// Default to 0 if not present
        self.credits = try container.decode(CreditsResponse.self, forKey: .credits)
        let similar = try container.decode(TMDBTVShowResponse.self, forKey: .similar)
        self.similar = similar as any TMDBPageResponseProtocol
    }
}
