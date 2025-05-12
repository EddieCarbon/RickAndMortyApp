//
//  EpisodeDetailsReducer.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct EpisodeDetailsReducer {
    @ObservableState
    struct State: Equatable, Identifiable {
        let episode: Episode
        
        var id: Int {
            episode.id
        }
        
        var characterCount: Int {
            episode.characters.count
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case onDismiss
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .onDismiss:
                return .none
            }
        }
    }
}
