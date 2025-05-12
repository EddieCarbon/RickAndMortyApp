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
        
        @Presents var episodeDetails: EpisodeDetailsReducer.State?
        
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
        
        var id: Int {
            character.id
        }
    }
    
    enum Action: Equatable {
        case onAppear
        case episodesResponse(TaskResult<[Episode]>)
        case episodeSelected(Episode)
        case episodeDetails(PresentationAction<EpisodeDetailsReducer.Action>)
    }
    
    @Dependency(\.rmClient) var rmClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.episodesState = .loading
                
                return .run { [episodeUrls = state.character.episode] send in
                    await send(.episodesResponse(TaskResult {
                        try await rmClient.fetchEpisodesByUrls(episodeUrls)
                    }))
                }
                
            case .episodesResponse(.success(let episodes)):
                state.episodesState = .loaded(episodes)
                return .none
                
            case .episodesResponse(.failure(let error)):
                state.episodesState = .error(error.localizedDescription)
                return .none
                
            case .episodeSelected(let episode):
                state.episodeDetails = EpisodeDetailsReducer.State(episode: episode)
                return .none
                
            case .episodeDetails(.presented(.onDismiss)):
                state.episodeDetails = nil
                return .none
                
            case .episodeDetails:
                return .none
            }
        }
        .ifLet(\.$episodeDetails, action: \.episodeDetails) {
            EpisodeDetailsReducer()
        }
    }
}
