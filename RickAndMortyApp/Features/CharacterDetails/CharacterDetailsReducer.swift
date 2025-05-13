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
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded([Episode])
        case error(String)
    }
    
    @ObservableState
    struct State: Equatable, Identifiable {
        let character: Character
        var episodesState: LoadingState = .idle
        var selectedEpisode: Episode?
        var isEpisodeSheetPresented: Bool = false
        
        var episodes: [Episode] {
            if case let .loaded(episodes) = episodesState {
                return episodes
            }
            return []
        }
        
        var isLoadingEpisodes: Bool {
            if case .loading = episodesState {
                return true
            }
            return false
        }
        
        var errorMessage: String? {
            if case let .error(message) = episodesState {
                return message
            }
            return nil
        }
        
        var characterCount: Int {
            selectedEpisode?.characters.count ?? 0
        }
        
        var id: Int {
            character.id
        }
    }
    
    enum Action: Equatable, BindableAction {
        case onAppear
        case episodesResponse(TaskResult<[Episode]>)
        case episodeSelected(Episode)
        case closeEpisodeSheet
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.rmClient) var rmClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.episodesState = .loading
                return .run { [episodesUrls = state.character.episode] send in
                    await send(.episodesResponse(TaskResult {
                        try await rmClient.fetchEpisodesByUrls(episodesUrls)
                    }))
                }
                
            case .episodesResponse(.success(let result)):
                state.episodesState = .loaded(result)
                return .none
                
            case .episodesResponse(.failure(let result)):
                state.episodesState = .error(result.localizedDescription)
                return .none
                
            case .episodeSelected(let episode):
                state.selectedEpisode = episode
                state.isEpisodeSheetPresented = true
                return .none
                
            case .closeEpisodeSheet:
                state.selectedEpisode = nil
                state.isEpisodeSheetPresented = false
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
