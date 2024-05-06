//
//  TMDBTVShowResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public struct TMDBTVShowResponse: TMDBPageResponseProtocol {
    public let page: Int
    public let results: [any TMDBItemResponseProtocol]
    public let totalPages: Int
    public let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        totalPages = try container.decode(Int.self, forKey: .totalPages)
        totalResults = try container.decode(Int.self, forKey: .totalResults)
        
        
        let results = try container.decode([TMDBTVShowItemResponse].self, forKey: .results)
        self.results = results as [any TMDBItemResponseProtocol]
    }
}
