//
//  CharacterFavouritesReducer.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct FavouritesCharactesReducer {
    @ObservableState
    struct State: Equatable {
        
    }
    
    enum Action: Equatable {

    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
