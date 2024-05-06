//
//  TMDBTVShowItemResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

struct TMDBTVShowItemResponse: TMDBItemResponseProtocol {
    let id: Int
    let title: String
    let voteAverage: Double
    let releaseDate: String?
    let backdropPath: String?
    let posterPath: String?
        
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case voteAverage = "vote_average"
        case releaseDate = "first_air_date"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}
