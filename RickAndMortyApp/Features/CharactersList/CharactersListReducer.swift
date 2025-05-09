//
//  CharactersListReducer.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CharactersListReducer {
    private static let favoritesKey = "favoriteCharacterIds"
    
    enum ViewState: Equatable {
        case welcome
        case loading
        case content
        case error(String)
    }
    
    @ObservableState
    struct State: Equatable {
        var characters: [Character] = []
        var favoriteCharacterIds: Set<Int>
        var isLoadingMore: Bool = false
        var viewState: ViewState = .welcome
        var selectedCharacter: Character?
        var currentPage: Int = 1
        var paginationInfo: PaginationInfo?
        var hasMorePages: Bool { paginationInfo?.next != nil }
        
        @Presents var characterDetails: CharacterDetailsReducer.State?
        
        init(
            characters: [Character] = [],
            favoriteCharacterIds: Set<Int> = [],
            isLoadingMore: Bool = false,
            viewState: ViewState = .welcome,
            selectedCharacter: Character? = nil,
            currentPage: Int = 1,
            paginationInfo: PaginationInfo? = nil
        ) {
            self.characters = characters
            self.favoriteCharacterIds = favoriteCharacterIds
            self.isLoadingMore = isLoadingMore
            self.viewState = viewState
            self.selectedCharacter = selectedCharacter
            self.currentPage = currentPage
            self.paginationInfo = paginationInfo
        }
    }
    
    enum Action: Equatable, BindableAction {
        case loadCharacters
        case loadMoreCharacters
        case resetView
        case charactersResponse(TaskResult<CharactersResult>)
        case moreCharactersResponse(TaskResult<CharactersResult>)
        case characterTapped(Character)
        case toggleFavorite(Character)
        case loadFavorites
        case favoritesLoaded(Set<Int>)
        case characterDetails(PresentationAction<CharacterDetailsReducer.Action>)
        case binding(BindingAction<State>)
    }
    
    @Dependency(\.rmClient) var rmClient
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .loadCharacters:
                state.viewState = .loading
                state.currentPage = 1
                
                return .run { send in
                    await send(.charactersResponse(TaskResult {
                        try await rmClient.fetchCharacters(1)
                    }))
                }
                
            case .loadMoreCharacters:
                guard !state.isLoadingMore, state.hasMorePages else {
                    return .none
                }
                
                state.isLoadingMore = true
                let nextPage = state.currentPage + 1
                
                return .run { send in
                    await send(.moreCharactersResponse(TaskResult {
                        try await rmClient.fetchCharacters(nextPage)
                    }))
                }
                
            case let .charactersResponse(.success(result)):
                state.characters = result.results
                state.paginationInfo = result.info
                state.currentPage = 1
                state.viewState = .content
                return .send(.loadFavorites)
                
            case let .moreCharactersResponse(.success(result)):
                state.isLoadingMore = false
                state.characters.append(contentsOf: result.results)
                state.paginationInfo = result.info
                state.currentPage += 1
                return .none
                
            case .charactersResponse(.failure(let error)):
                state.viewState = .error(error.localizedDescription)
                return .none
                
            case .moreCharactersResponse(.failure(let error)):
                state.isLoadingMore = false
                state.viewState = .error(error.localizedDescription)
                return .none
                
            case .resetView:
                state.viewState = .welcome
                state.currentPage = 1
                state.characters = []
                state.paginationInfo = nil
                return .none
                
            case .characterTapped(let character):
                state.characterDetails = .init(character: character)
                return .none
                
            case .toggleFavorite(let character):
                if state.favoriteCharacterIds.contains(character.id) {
                    state.favoriteCharacterIds.remove(character.id)
                } else {
                    state.favoriteCharacterIds.insert(character.id)
                }
                
                let defaults = UserDefaults.standard
                defaults.set(Array(state.favoriteCharacterIds), forKey: Self.favoritesKey)
                return .none
                
            case .loadFavorites:
                return .run { send in
                    let defaults = UserDefaults.standard
                    let favoriteIds = defaults.array(forKey: Self.favoritesKey) as? [Int] ?? []
                    await send(.favoritesLoaded(Set(favoriteIds)))
                }
                
            case .favoritesLoaded(let favoriteIds):
                state.favoriteCharacterIds = favoriteIds
                return .none
                
            case .characterDetails:
                return .none
                
            case .binding:
                return .none
            }
        }
        .ifLet(\.$characterDetails, action: \.characterDetails) {
            CharacterDetailsReducer()
        }
    }
}
