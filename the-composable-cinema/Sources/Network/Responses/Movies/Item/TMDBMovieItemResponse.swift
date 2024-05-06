//
//  TMDBMovieItemResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

struct TMDBMovieItemResponse: TMDBItemResponseProtocol, Equatable {
    let id: Int
    let title: String
    let voteAverage: Double
    let releaseDate: String?
    let backdropPath: String?
    let posterPath: String?
        
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}
