//
//  CharacterDetailsReducer.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CharacterDetailsReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let character: Character
        
        var id: Int {
            character.id
        }
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
