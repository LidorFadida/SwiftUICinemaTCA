//
//  TMDBDiscoverResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation

public struct TMDBDiscoverResponse {
    public let items: [TMDBPageItemResponse]
    
    public init(items: [TMDBPageItemResponse]) {
        self.items = items
    }
}
