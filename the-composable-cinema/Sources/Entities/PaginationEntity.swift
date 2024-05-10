//
//  PaginationEntity.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Foundation
import Network
import Dependencies
import TMDBCore
import Extensions

public struct PaginationEntity: Equatable, Identifiable {
    public let id: String
    public let title: String
    public let page: Int
    public let totalPages: Int
    public let entertainmentCategory: EntertainmentCategory
    public let items: [DiscoverItemEntity]
    
    public init(
        id: String,
        title: String,
        page: Int,
        totalPages: Int,
        entertainmentCategory: EntertainmentCategory,
        items: [DiscoverItemEntity]
    ) {
        self.id = id
        self.title = title
        self.page = page
        self.totalPages = totalPages
        self.entertainmentCategory = entertainmentCategory
        self.items = items
    } 
    
    public init(
        title: String,
        page: Int,
        totalPages: Int,
        entertainmentCategory: EntertainmentCategory,
        items: [DiscoverItemEntity]
    ) {
        @Dependency(\.uuid) var uuid
        self.init(
            id: uuid().uuidString,
            title: title,
            page: page,
            totalPages: totalPages,
            entertainmentCategory: entertainmentCategory,
            items: items
        )
    }
    
    public init(entertainmentCategory: EntertainmentCategory, response: any TMDBPageResponseProtocol) {
        @Dependency(\.uuid) var uuid
        self.id = uuid().uuidString
        self.title = entertainmentCategory.title
        self.page = response.page
        self.totalPages = response.totalPages
        self.entertainmentCategory = entertainmentCategory
        
        let imageLargeSizeURLPath = TMDBCoreProperties.Constants.imageLargeSizeURLPath
        let imageMediumSizeURLPath = TMDBCoreProperties.Constants.imageMediumSizeURLPath
        let items = response.results.compactMap {
            var backdropPath: URL?
            if let backdrop = $0.backdropPath {
                backdropPath = URL(string: imageLargeSizeURLPath + backdrop)
            }
            
            var posterPath: URL?
            if let poster = $0.posterPath {
                posterPath = URL(string: imageMediumSizeURLPath + poster)
            }
            let releaseDate = DateFormatter.convertDateString($0.releaseDate)
            return DiscoverItemEntity(id: uuid().uuidString,
                                      itemIdentifier: $0.id,
                                      title: $0.title,
                                      rating: $0.voteAverage,
                                      releaseDate: releaseDate,
                                      backdropPath: backdropPath,
                                      posterPath: posterPath)
        }
        self.items = items
    }
}
