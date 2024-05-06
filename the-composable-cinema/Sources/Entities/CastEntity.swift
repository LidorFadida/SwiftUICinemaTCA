//
//  CastEntity.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 02/05/2024.
//

import Foundation

public struct CastEntity: Identifiable, Equatable {
    public let id: String
    public let profileURL: URL?
    public let name: String
    public let characterName: String
    
    public init(id: String, profileURL: URL?, name: String, characterName: String) {
        self.id = id
        self.profileURL = profileURL
        self.name = name
        self.characterName = characterName
    }
}
