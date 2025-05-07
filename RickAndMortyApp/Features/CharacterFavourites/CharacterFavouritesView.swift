//
//  CharacterFavouritesView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct FavouritesCharactesView: View {
    let store: StoreOf<FavouritesCharactesReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FavouritesCharactesView(
        store: Store(
            initialState: FavouritesCharactesReducer.State(),
            reducer: {
                FavouritesCharactesReducer()
            }
        )
    )
}
