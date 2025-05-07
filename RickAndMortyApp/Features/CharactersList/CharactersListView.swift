//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct CharactersListView: View {
    let store: StoreOf<CharactersListReducer>
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    CharactersListView(
        store: Store(
            initialState: CharactersListReducer.State(),
            reducer: {
                CharactersListReducer()
            }
        )
    )
}
