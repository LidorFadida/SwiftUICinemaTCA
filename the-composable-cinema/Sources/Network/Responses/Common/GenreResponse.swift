//
//  GenreResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public struct GenreResponse: Decodable, Equatable {
    public let id: Int?
    public let name: String?
}
