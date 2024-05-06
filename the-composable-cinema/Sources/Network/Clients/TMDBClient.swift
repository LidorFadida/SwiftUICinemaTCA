//
//  TMDBClient.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation
import Alamofire
import TMDBCore

///Default client implementation supplied by this library ready to use.
public struct TMDBClient: TMDBClientProtocol {
    
    public init() {}
    
    public func fetchDetails(id: Int, entertainmentCategory: EntertainmentCategory) async throws -> TMDBItemDetailsResponseProtocol {
        let parameters = TMDBCoreProperties.Parameters(page: nil, appendToResponse: ["credits", "similar"])
        let response: any TMDBItemDetailsResponseProtocol
        let entertainmentCategory = entertainmentCategory.asDetailsCategory
        switch entertainmentCategory {
        case let .movies(moviesPath):
            let url = "\(moviesPath.urlString)/\(id)"
            let result = try await AF.request(url, parameters: parameters, headers: TMDBCoreProperties.Constants.headers)
                .validate()
                .serializingDecodable(TMDBMovieDetailsResponse.self)
                .value
            response = result
            
        case let .tvShows(tVShowsPath):
            let url = "\(tVShowsPath.urlString)/\(id)"
            let result = try await AF.request(url, parameters: parameters, headers: TMDBCoreProperties.Constants.headers)
                .validate()
                .serializingDecodable(TMDBTVShowDetailsResponse.self)
                .value
            response = result
        }
        return response
    }
    
    public func fetchMovies() async throws -> TMDBDiscoverResponse {
        let parameters = TMDBCoreProperties.Parameters(page: 1)
        let nowPlayingCategory: EntertainmentCategory = .movies(.nowPlaying)
        let popularCategory: EntertainmentCategory = .movies(.popular)
        let topRatedCategory: EntertainmentCategory = .movies(.topRated)
        
        async let nowPlayingResult = try fetchTMDBPage(entertainmentCategory: nowPlayingCategory, parameters: parameters)
        async let popularResult = try fetchTMDBPage(entertainmentCategory: popularCategory, parameters: parameters)
        async let topRatedResult = try fetchTMDBPage(entertainmentCategory: topRatedCategory, parameters: parameters)
        
        let items = try await [nowPlayingResult, popularResult, topRatedResult] //task group
        let fetched = TMDBDiscoverResponse(items: items)
        return fetched
    }
    
    public func fetchTVShows() async throws -> TMDBDiscoverResponse {
        let parameters = TMDBCoreProperties.Parameters(page: 1)
        let onTheAirCategory: EntertainmentCategory = .tvShows(.onTheAir)
        let popularCategory: EntertainmentCategory = .tvShows(.popular)
        let topRatedCategory: EntertainmentCategory = .tvShows(.topRated)
        
        async let onAirResult = try fetchTMDBPage(entertainmentCategory: onTheAirCategory, parameters: parameters)
        async let popularResult = try fetchTMDBPage(entertainmentCategory: popularCategory, parameters: parameters)
        async let topRatedResult = try fetchTMDBPage(entertainmentCategory: topRatedCategory, parameters: parameters)
        
        let items = try await [onAirResult, popularResult, topRatedResult]
        let fetched = TMDBDiscoverResponse(items: items)
        return fetched
    }
    
    public func fetchTMDBPage(entertainmentCategory: EntertainmentCategory, parameters: TMDBCoreProperties.Parameters) async throws -> TMDBPageItemResponse {
        let response: any TMDBPageResponseProtocol
        
        switch entertainmentCategory {
        case let .movies(moviesPath):
            let url = moviesPath.urlString
            let result = try await AF.request(url, parameters: parameters, headers: TMDBCoreProperties.Constants.headers)
                .validate()
                .serializingDecodable(TMDBMoviesPageResponse.self)
                .value
            response = result
            
        case let .tvShows(tVShowsPath):
            let url = tVShowsPath.urlString
            let result = try await AF.request(url, parameters: parameters, headers: TMDBCoreProperties.Constants.headers)
                .validate()
                .serializingDecodable(TMDBTVShowResponse.self)
                .value
            response = result
        }
        return TMDBPageItemResponse(entertainmentCategory: entertainmentCategory, response: response)
    }
}
