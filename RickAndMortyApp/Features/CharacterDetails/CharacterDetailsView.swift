//
//  CharacterDetailsView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct CharacterDetailsView: View {
    let store: StoreOf<CharacterDetailsReducer>
    
    var body: some View {
        Text(store.character.name)
    }
}

#Preview {
    CharacterDetailsView(
        store: Store(
            initialState: CharacterDetailsReducer.State(
                character: Character(
                    id: 1,
                    name: "Rick Sanchez",
                    status: "Alive",
                    species: "Human",
                    type: "",
                    gender: "Male",
                    origin: Location(name: "Earth", url: ""),
                    location: Location(name: "Earth", url: ""),
                    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    episode: ["https://rickandmortyapi.com/api/episode/1"],
                    url: "",
                    created: ""
                )
            ),
            reducer: {
                CharacterDetailsReducer()
            }
        )
    )
}
