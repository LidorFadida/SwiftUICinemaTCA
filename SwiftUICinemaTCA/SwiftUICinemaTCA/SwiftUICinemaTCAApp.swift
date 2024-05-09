//
//  SwiftUICinemaTCAApp.swift
//  SwiftUICinemaTCA
//
//  Created by Lidor Fadida on 05/05/2024.
//

import SwiftUI
import AppFeature

@main
struct SwiftUICinemaTCAApp: App {
    let appConfigurator = AppConfigurator(/*apiKey: your api key */)
    
    var body: some Scene {
        WindowGroup {
            AppView(store: appConfigurator.store)
        }
    }
}
