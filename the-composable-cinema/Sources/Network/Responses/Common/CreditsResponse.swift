//
//  CreditsResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public struct CreditsResponse: Decodable, Equatable {
    public let cast: [CastResponse]
    
    public struct CastResponse: Decodable, Equatable {
        public let name: String
        public let profilePath: String?
        public let order: Int
        public let character: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case profilePath = "profile_path"
            case order
            case character
        }
    }
}


