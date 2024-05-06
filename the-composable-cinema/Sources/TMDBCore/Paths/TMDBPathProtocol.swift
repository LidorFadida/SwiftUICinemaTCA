//
//  TMDBPathProtocol.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 05/05/2024.
//

import Foundation

public protocol TMDBPathProtocol: Equatable {
    var urlString: String { get }
    var route: String { get }
    var title: String { get }
}
