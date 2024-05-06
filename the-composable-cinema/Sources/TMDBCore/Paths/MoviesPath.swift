//
//  MoviesPath.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Foundation

public enum MoviesPath: TMDBPathProtocol {
    case topRated
    case popular
    case nowPlaying
    case search
    case trending
    case details
    
    public var urlString: String {
        let baseURL = TMDBCoreProperties.Constants.baseURL
        switch self {
        case .topRated: return "\(baseURL)/\(route)/top_rated"
        case .popular: return "\(baseURL)/\(route)/popular"
        case .nowPlaying: return "\(baseURL)/\(route)/now_playing"
        case .search: return "\(baseURL)/search/\(route)"
        case .trending: return "\(baseURL)/trending/\(route)/week"
        case .details: return "\(baseURL)/\(route)"
        }
    }
    
    public var route: String {
        return "movie"
    }

    public var title: String {
        switch self {
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        case .nowPlaying: return "Now Playing"
        case .search: return "Search Movies"
        case .trending: return "Trending This Week"
        case .details: return "Movie Details"
        }
    }
    
    public var description: String {
        return "Movies"
    }
}
