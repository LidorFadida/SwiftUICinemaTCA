//
//  TMDBMocker.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 01/05/2024.
//

import UIKit
import TMDBCore
import Network

///For testing purposes
public struct TMDBMocker {
    
    public init() { }
    
    var nowPlayingMovies: TMDBMoviesPageResponse {
        let response: TMDBMoviesPageResponse = try! Bundle.module.loadAndDecodeJSON(filename: "now_playing")
        return response
    }
    
    var popularMovies: TMDBMoviesPageResponse {
        let response: TMDBMoviesPageResponse = try! Bundle.module.loadAndDecodeJSON(filename: "popular")
        return response
    }
    
    var topRatedMovies: TMDBMoviesPageResponse {
        let response: TMDBMoviesPageResponse = try! Bundle.module.loadAndDecodeJSON(filename: "topRated")
        return response
    }
    
    var mockedMovieDetails: TMDBMovieDetailsResponse {
        let response: TMDBMovieDetailsResponse = try! Bundle.module.loadAndDecodeJSON(filename: "movie_details")
        return response
    }
    
    ///TV Shows
    var tvShowsPopular: TMDBTVShowResponse {
        let response: TMDBTVShowResponse = try! Bundle.module.loadAndDecodeJSON(filename: "tv_popular")
        return response
    }
    
    var tvShowsTopRated: TMDBTVShowResponse {
        let response: TMDBTVShowResponse = try! Bundle.module.loadAndDecodeJSON(filename: "tv_top_rated")
        return response
    }
    
    var tvShowsOnAir: TMDBTVShowResponse {
        let response: TMDBTVShowResponse = try! Bundle.module.loadAndDecodeJSON(filename: "tv_top_rated")
        return response
    }
}

extension TMDBMocker: TMDBClientProtocol {
    
    public func fetchDetails(id: Int, entertainmentCategory: EntertainmentCategory) async throws -> TMDBItemDetailsResponseProtocol {
        switch entertainmentCategory {
        case .movies(_):
            return mockedMovieDetails
        case .tvShows(_):
            return mockedMovieDetails /// should add tv shows file.
        }
    }
    
    public func fetchDiscover(categories: [EntertainmentCategory]) async throws -> TMDBDiscoverResponse {
        guard let dummy = categories.first else { throw NSError(domain: "tmdbMock", code: -1) }
        switch dummy {
        case .movies(_):
            return try await fetchMovies()
        case .tvShows(_):
            return try await fetchTVShows()
        }
    }
    
    public func fetchTMDBPage(entertainmentCategory: EntertainmentCategory, parameters: TMDBCoreProperties.Parameters) async throws -> TMDBPageItemResponse {
        switch entertainmentCategory {
        case .movies(_):
            let nowPlayingMovies = TMDBPageItemResponse(entertainmentCategory: entertainmentCategory, response: nowPlayingMovies)
            return nowPlayingMovies
        case .tvShows(_):
            let nowPlayingMovies = TMDBPageItemResponse(entertainmentCategory: entertainmentCategory, response: tvShowsOnAir)
            return nowPlayingMovies
        }
        
    }
}

extension TMDBMocker {
    private func fetchMovies() async throws -> TMDBDiscoverResponse {
        let nowPlayingMovies = TMDBPageItemResponse(entertainmentCategory: .movies(.nowPlaying), response: nowPlayingMovies)
        let popularMovies = TMDBPageItemResponse(entertainmentCategory: .movies(.popular), response: popularMovies)
        let topRatedMovies = TMDBPageItemResponse(entertainmentCategory: .movies(.topRated), response: topRatedMovies)
        return TMDBDiscoverResponse(items: [nowPlayingMovies, popularMovies, topRatedMovies])
    }
    
    private func fetchTVShows() async throws -> TMDBDiscoverResponse {
        let tvShowsPopular = TMDBPageItemResponse(entertainmentCategory: .movies(.popular), response: tvShowsPopular)
        let tvShowsTopRated = TMDBPageItemResponse(entertainmentCategory: .movies(.topRated), response: tvShowsTopRated)
        let tvShowsOnAir = TMDBPageItemResponse(entertainmentCategory: .movies(.nowPlaying), response: tvShowsOnAir)
        return TMDBDiscoverResponse(items: [tvShowsPopular, tvShowsTopRated, tvShowsOnAir])
    }
}

///private Bundle extension utility to load JSON.
private extension Bundle {
    func loadAndDecodeJSON<T: Decodable>(filename: String) throws -> T {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            throw NSError(domain: "", code: 11)
        }
        let data = try! Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let decodedModel = try! jsonDecoder.decode(T.self, from: data)
        return decodedModel
    }
}
