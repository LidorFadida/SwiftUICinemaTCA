//
//  TVShowsPath.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Foundation

public enum TVShowsPath: TMDBPathProtocol {
    case topRated
    case popular
    case onTheAir
    case search
    case trending
    case details
    
    public var urlString: String {
        let baseURL = TMDBCoreProperties.Constants.baseURL
        switch self {
        case .topRated: return "\(baseURL)/\(route)/top_rated"
        case .popular: return "\(baseURL)/\(route)/popular"
        case .onTheAir: return "\(baseURL)/\(route)/on_the_air"
        case .search: return "\(baseURL)/search/\(route)"
        case .trending: return "\(baseURL)/trending/\(route)/week"
        case .details: return "\(baseURL)/\(route)"
        }
    }
    
    public var route: String {
        return "tv"
    }
    
    public var title: String {
        switch self {
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        case .onTheAir: return "On The Air"
        case .search: return "Search TV Show"
        case .trending: return "Trending This Week"
        case .details: return "TV Show Details"
        }
    }
    
    public var description: String {
        return "TV Shows"
    }
}
