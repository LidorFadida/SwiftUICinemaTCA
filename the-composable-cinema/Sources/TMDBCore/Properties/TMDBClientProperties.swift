//
//  TMDBClientProperties.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Foundation
import Alamofire

public struct TMDBCoreProperties {
    
    public struct Constants {
        public static let imageSmallSizeURLPath = "https://image.tmdb.org/t/p/w185"
        public static let imageMediumSizeURLPath = "https://image.tmdb.org/t/p/w780"
        public static let imageLargeSizeURLPath = "https://image.tmdb.org/t/p/w1280"
        public static let baseURL = "https://api.themoviedb.org/3"
        public static let paginationThreshold = 500
        public static let headers: HTTPHeaders = {
            guard let apiKey = TMDBCore.shared.apiKey else { fatalError("Forgot to call TMDBCore.configure(sdkKey:_) ? ;)") }
            return [.authorization(apiKey),
                    .accept("application/json")]
        }()
    }

    public struct Parameters: Encodable {
        public let page: Int?
        public let searchQuery: String?
        public let language: String
        public let appendToResponse: String?
        
        public init(
            page: Int? = nil,
            searchQuery: String? = nil,
            language: String = "en-US",
            appendToResponse: [String] = []
        ) {
            self.page = page
            self.searchQuery = searchQuery
            self.language = language
            guard !appendToResponse.isEmpty else { self.appendToResponse = nil; return }
            let append = appendToResponse.joined(separator: ",")
            self.appendToResponse = append
        }
        
        enum CodingKeys: String, CodingKey {
            case language
            case page
            case searchQuery = "query"
            case appendToResponse = "append_to_response"
        }
    }
}
