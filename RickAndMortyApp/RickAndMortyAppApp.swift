//
//  RickAndMortyAppApp.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

@main
struct RickAndMortyAppApp: App {
    var body: some Scene {
        WindowGroup {
            CharactersListView(store: .init(initialState: .init(), reducer: { CharactersListReducer() }))
        }
    }
}
