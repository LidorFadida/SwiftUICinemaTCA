//
//  DetailsFeatureTests.swift
//  the-composable-cinema
//
//  Created by Lidor Fadida on 06/05/2024.
//

import XCTest
import ComposableArchitecture
import Details
import TMDBCore
import TMDBMock
import Entities

@MainActor
final class DetailsFeatureTests: XCTestCase {
    let mocker = TMDBMocker()
    
    func testMovieDetailsFeature() async {
        let item = try! await mocker.fetchDetails(id: 1, entertainmentCategory: .movies(.details))
        
        let itemDetails = withDependencies { container in
            container.uuid = .incrementing
        } operation: {
            DetailsEntity(itemDetailsResponse: item)
        }
 
        let store = TestStore(initialState: DetailsFeature.State(itemIdentifier: 1, entertainmentCategory: .movies(.details))) {
            DetailsFeature()
        } withDependencies: { container in
            container.uuid = .incrementing
        }
        
        await store.send(.view(.fetchItemDetails))
        await store.receive(\.itemDetailsResponse) { state in
            state.itemDetails = itemDetails
        }
        
        await store.send(.view(.similarItemTapped(-1)))
    }
    
}
