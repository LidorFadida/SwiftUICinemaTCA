//
//  TMDBPageItemResponse.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 04/05/2024.
//

import Foundation
import TMDBCore

public struct TMDBPageItemResponse {
    public let entertainmentCategory: EntertainmentCategory
    public let response: any TMDBPageResponseProtocol
    
    public init(entertainmentCategory: EntertainmentCategory, response: any TMDBPageResponseProtocol) {
        self.entertainmentCategory = entertainmentCategory
        self.response = response
    }
}

