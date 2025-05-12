//
//  CharacterDetailsView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Kingfisher
import SwiftUI

struct CharacterDetailsView: View {
    @ComposableArchitecture.Bindable var store: StoreOf<CharacterDetailsReducer>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                characterHeader
                characterImage
                characterInfo
                episodesList
            }
            .padding()
        }
        .navigationTitle(store.character.name)
        .navigationBarTitleDisplayMode(.large)
        .task { await store.send(.onAppear).finish() }
        .sheet(item: $store.scope(state: \.episodeDetails, action: \.episodeDetails)) { store in
            WithPerceptionTracking {
                NavigationView {
                    EpisodeDetailsView(store: store)
                        .navigationTitle("Episode Details")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Close") {
                                    self.store.send(.episodeDetails(.presented(.onDismiss)))
                                }
                            }
                        }
                }
            }
        }
    }
    
    // Character header with status
    private var characterHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(spacing: 8) {
                Circle()
                    .fill(statusColor)
                    .frame(width: 10, height: 10)
                
                Text(store.character.status)
                    .font(.headline)
            }
        }
    }
    
    // Character image
    private var characterImage: some View {
        KFImage(URL(string: store.character.image))
            .placeholder {
                ProgressView()
                    .frame(height: 300)
            }
            .retry(maxCount: 3, interval: .seconds(2))
            .onFailure { error in
                print("Kingfisher error loading image: \(error)")
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
    }
    
    // Character information details
    private var characterInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Character Info")
                .font(.headline)
                .padding(.vertical, 4)
            
            infoRow(title: "Species", value: store.character.species)
            infoRow(title: "Gender", value: store.character.gender)
            infoRow(title: "Origin", value: store.character.origin.name)
            infoRow(title: "Location", value: store.character.location.name)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    // Episodes list section
    private var episodesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Episodes")
                .font(.headline)
                .padding(.top, 8)
            
            switch store.episodesState {
            case .idle:
                EmptyView()
                
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
                
            case .error(let message):
                Text("Error: \(message)")
                    .foregroundColor(.red)
                    .padding()
                
            case .loaded(let episodes):
                if episodes.isEmpty {
                    Text("No episodes found")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(episodes) { episode in
                        Button {
                            store.send(.episodeSelected(episode))
                        } label: {
                            HStack {
                                Text(episode.episode)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color(.tertiarySystemBackground))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
    
    // Helper function to create info rows
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .fontWeight(.semibold)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // Helper computed property for status color
    private var statusColor: Color {
        switch store.character.status.lowercased() {
        case "alive":
            return .green
        case "dead":
            return .red
        default:
            return .gray
        }
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
                    episode: [
                        "https://rickandmortyapi.com/api/episode/1",
                        "https://rickandmortyapi.com/api/episode/2",
                        "https://rickandmortyapi.com/api/episode/3"
                    ],
                    url: "",
                    created: ""
                ),
                episodesState: .loaded([
                    Episode(id: 1, name: "Pilot", airDate: "December 2, 2013", episode: "S01E01", characters: [], url: "", created: ""),
                    Episode(id: 2, name: "Lawnmower Dog", airDate: "December 9, 2013", episode: "S01E02", characters: [], url: "", created: ""),
                    Episode(id: 3, name: "Anatomy Park", airDate: "December 16, 2013", episode: "S01E03", characters: [], url: "", created: "")
                ])
            ),
            reducer: {
                CharacterDetailsReducer()
            }
        )
    )
}
