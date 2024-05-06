//
//  TMDBClientProtocol.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation
import TMDBCore

public protocol TMDBClientProtocol {
    func fetchDetails(id: Int, entertainmentCategory: EntertainmentCategory) async throws -> TMDBItemDetailsResponseProtocol
    func fetchMovies() async throws -> TMDBDiscoverResponse ///should enable selective categories.
    func fetchTVShows() async throws -> TMDBDiscoverResponse ///should enable selective categories.
    func fetchTMDBPage(entertainmentCategory: EntertainmentCategory, parameters: TMDBCoreProperties.Parameters) async throws -> TMDBPageItemResponse
}
