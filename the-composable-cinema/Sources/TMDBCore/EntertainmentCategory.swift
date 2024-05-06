//
//  EntertainmentCategory.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Foundation

public enum EntertainmentCategory: Equatable {
    case movies(MoviesPath)
    case tvShows(TVShowsPath)
    
    public var isMovieCategory: Bool {
        switch self {
        case .movies(_): return true
        case .tvShows(_): return false
        }
    }
    
    public var route: String {
        switch self {
        case let .movies(path): return path.route
        case let .tvShows(path): return path.route
        }
    }
    
    public var title: String {
        switch self {
        case let .movies(path): return path.title
        case let .tvShows(path): return path.title
        }
    }
    
    public var description: String {
        switch self {
        case let .movies(path): return path.description
        case let .tvShows(path): return path.description
        }
    }
    
    public var asDetailsCategory: EntertainmentCategory {
        switch self {
        case .movies(_): return .movies(.details)
        case .tvShows(_): return .tvShows(.details)
        }
    }
}
