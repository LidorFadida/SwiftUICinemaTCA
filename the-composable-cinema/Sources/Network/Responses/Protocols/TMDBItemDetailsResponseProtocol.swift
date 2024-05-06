//
//  TMDBItemDetailsResponseProtocol.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation


public protocol TMDBItemDetailsResponseProtocol: Decodable {
    var title: String { get }
    var voteAverage: Double { get }
    var releaseDate: String { get }
    var backdropPath: String? { get }
    var overview: String? { get }
    var genres: [GenreResponse] { get }
    var runtime: Int { get }
    var credits: CreditsResponse { get }
    var similar: any TMDBPageResponseProtocol { get }
}
