//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct EpisodeDetailsView: View {
    @ComposableArchitecture.Bindable var store: StoreOf<EpisodeDetailsReducer>
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                episodeHeader
                episodeDetails
                characterCount
            }
            .padding()
        }
        .task { await store.send(.onAppear).finish() }
    }
    
    private var episodeHeader: some View {
        Text(store.episode.name)
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.bottom, 2)
    }
    
    private var episodeDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Episode Info")
                .font(.headline)
                .padding(.vertical, 4)
            
            infoRow(title: "Episode", value: store.episode.episode)
            infoRow(title: "Air Date", value: store.episode.airDate)
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
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
    
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(title):")
                .fontWeight(.semibold)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    EpisodeDetailsView(
        store: Store(
            initialState: EpisodeDetailsReducer.State(
                episode: Episode(
                    id: 1,
                    name: "Pilot",
                    airDate: "December 2, 2013",
                    episode: "S01E01",
                    characters: [
                        "https://rickandmortyapi.com/api/character/1",
                        "https://rickandmortyapi.com/api/character/2",
                        "https://rickandmortyapi.com/api/character/35"
                    ],
                    url: "https://rickandmortyapi.com/api/episode/1",
                    created: "2017-11-10T12:56:33.798Z"
                )
            ),
            reducer: {
                EpisodeDetailsReducer()
            }
        )
    )
}
