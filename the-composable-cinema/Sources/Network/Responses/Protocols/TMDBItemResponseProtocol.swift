//
//  TMDBItemResponseProtocol.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public protocol TMDBItemResponseProtocol: Decodable, Equatable {
    var id: Int { get }
    var title: String { get }
    var voteAverage: Double { get }
    var backdropPath: String? { get }
    var releaseDate: String? { get }
    var posterPath: String? { get }
}
