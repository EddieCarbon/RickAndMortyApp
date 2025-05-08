//
//  CharacterListView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct CharactersListView: View {
    @ComposableArchitecture.Bindable var store: StoreOf<CharactersListReducer>
    
    var body: some View {
        NavigationView {
            ZStack {
                switch store.viewState {
                case .welcome:
                    welcomeView
                case .loading:
                    loadingView
                case .content:
                    charactersContentView
                case .error(let message):
                    errorView(message: message)
                }
            }
            .navigationTitle(store.viewState == .welcome ? "" : "Characters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if case .content = store.viewState {
                        Button {
                            store.send(.resetView)
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
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

extension CharactersListView {
    private var welcomeView: some View {
        VStack(spacing: 15) {
            Image("morty-smith")
                .resizable()
                .frame(width: 150, height: 150)
                .scaledToFill()
                .clipShape(Circle())
                .shadow(radius: 5)
            
            Text("Oh jeez, hej wszystkim!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("*Uhh, ta aplikacja p-pozwala przeglądać postacie z Rick and Morty, wiesz, mnie, Ricka i innych. M-możesz zobaczyć różne informacje o każdym z nas i sprawdzić w-w jakich odcinkach się pojawiamy. \nRick mówi, że to głupie, ale ja myślę, że to całkiem fajne.*")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Button {
                store.send(.loadCharacters)
            } label: {
                Text("Wczytaj postacie")
                    .font(.subheadline)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.capsule)
        }
        .padding()
    }
    
    private var loadingView: some View {
        ProgressView()
    }
    
    private var charactersContentView: some View {
        ScrollView {
            WithPerceptionTracking {
                LazyVStack(spacing: 20) {
                    ForEach(store.characters, id: \.id) { character in
                        characterNavigationButton(character)
                    }
                    
                    if store.hasMorePages {
                        ProgressView()
                            .onAppear {
                                store.send(.loadMoreCharacters)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .refreshable {
            store.send(.loadCharacters)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Text("Błąd")
                .font(.title)
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
            Button("Spróbuj ponownie") {
                store.send(.loadCharacters)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding()
    }
    
    private func characterNavigationButton(_ character: Character) -> some View {
        NavigationLinkStore(
            store.scope(state: \.$characterDetails, action: \.characterDetails),
            id: character.id
        ) {
            store.send(.characterTapped(character))
        } destination: { store in
            CharacterDetailsView(store: store)
        } label: {
            CharacterRowView(character, isFavourte: store.favoriteCharacterIds.contains(character.id) == true)
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                store.send(.toggleFavorite(character))
            } label: {
                Label(
                    store.favoriteCharacterIds.contains(character.id) ? "Usuń z ulubionych" : "Dodaj do ulubionych",
                    systemImage: store.favoriteCharacterIds.contains(character.id) ? "star.slash" : "star.fill"
                )
            }
        }
    }
}

struct CharacterRowView: View {
    let character: Character
    var isFavourite: Bool
    
    init(
        _ character: Character,
        isFavourte: Bool = false
    ) {
        self.character = character
        self.isFavourite = isFavourte
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AvatarView(url: character.image)
            
            VStack(alignment: .leading) {
                Text(character.name)
                    .font(.headline)
                    .foregroundStyle(.text)
                
                Text("\(character.status), \(character.species)")
                    .font(.subheadline)
                    .foregroundStyle(.text)
                    .opacity(0.9)
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            
            if isFavourite {
                Image(systemName: "star.fill")
                    .font(.headline)
                    .foregroundStyle(.yellow)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
    }
}

#Preview {
    CharacterRowView(
        Character(
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
    )
}

struct AvatarView: View {
    var url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 50, height: 50)
        .background(Color.gray.opacity(0.2))
        .clipShape(Circle())
    }
}

#Preview {
    AvatarView(url: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
}
