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
 
    public func fetchDiscover(categories: [EntertainmentCategory]) async throws -> TMDBDiscoverResponse {
        let parameters = TMDBCoreProperties.Parameters(page: 1)
        return try await withThrowingTaskGroup(of: (Int, TMDBPageItemResponse).self) { group in
            for (index, category) in categories.enumerated() {
                group.addTask {
                    do {
                        return (index, try await fetchTMDBPage(entertainmentCategory: category, parameters: parameters))
                    } catch {
                        assertionFailure("Error fetching category \(category): \(error)")
                        throw error
                    }
                }
            }
            
            let responses: [TMDBPageItemResponse] = try await group
                .reduce(into: [TMDBPageItemResponse?](repeating: nil, count: categories.count)) { partialResult, enumeratedResponse in
                    return partialResult[enumeratedResponse.0] = enumeratedResponse.1
                }
                .compactMap { $0 }

            return TMDBDiscoverResponse(items: responses)
        }
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
