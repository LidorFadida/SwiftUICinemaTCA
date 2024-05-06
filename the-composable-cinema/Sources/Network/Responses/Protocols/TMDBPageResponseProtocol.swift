//
//  TMDBPageResponseProtocol.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public protocol TMDBPageResponseProtocol: Decodable {
    var page: Int { get }
    var results: [any TMDBItemResponseProtocol] { get }
    var totalPages: Int { get }
    var totalResults: Int { get }
}
