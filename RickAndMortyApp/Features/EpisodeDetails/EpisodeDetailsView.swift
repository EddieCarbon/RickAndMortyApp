//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct EpisodeDetailsView: View {
    @ComposableArchitecture.Bindable var store: StoreOf<CharacterDetailsReducer>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                episodeHeader
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        episodeDetails
                        characterCount
                    }
                    .padding()
                }
            }
        }
    }
    
    private var episodeHeader: some View {
        HStack {
            Text(store.selectedEpisode?.name ?? "Error")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 2)
            
            Spacer()
            
            Button {
                store.send(.closeEpisodeSheet)
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.text)
            }
        }
        .padding(.top)
        .padding(.horizontal)
    }
    
    private var episodeDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Episode Info")
                .font(.headline)
                .padding(.vertical, 4)
            
            infoRow(title: "Episode", value: store.selectedEpisode?.episode)
            infoRow(title: "Air Date", value: store.selectedEpisode?.airDate)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var characterCount: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Characters")
                .font(.headline)
                .padding(.top, 8)
            
            Text("This episode features \(store.characterCount) character\(store.characterCount == 1 ? "" : "s").")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
    
    private func infoRow(title: String, value: String?) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .fontWeight(.semibold)
                .frame(width: 80, alignment: .leading)
            
            Text(value ?? "Error")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    EpisodeDetailsView(
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
