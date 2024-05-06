//
//  AppConfigurator.swift
//  SwiftUICinemaTCA
//
//  Created by Lidor Fadida on 06/05/2024.
//

import Foundation
import ComposableArchitecture
import Dependencies
import AppFeature
import TMDBMock

///To see real data setup your API key (TMDB) at: https://www.themoviedb.org/settings/api
class AppConfigurator {
    private let apiKey: String?
    
    init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }
    
    private var mock: Bool {
        return (apiKey == nil)
    }
    
    lazy var store: Store = {
        return Store(initialState: AppFeature.State(), reducer: {
            if mock {
                AppFeature(apiKey: apiKey)
                    .dependency(\.theMovieDatabaseClient, TMDBMocker())
            } else {
                AppFeature(apiKey: apiKey)
            }
        })
    }()
}
