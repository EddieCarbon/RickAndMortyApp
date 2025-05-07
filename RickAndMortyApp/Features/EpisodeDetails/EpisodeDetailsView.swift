//
//  EpisodeDetailsView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct EpisodeDetailsView: View {
    let store: StoreOf<EpisodeDetailsReducer>
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    EpisodeDetailsView(
        store: Store(
            initialState: EpisodeDetailsReducer.State(),
            reducer: {
                EpisodeDetailsReducer()
            }
        )
    )
}
