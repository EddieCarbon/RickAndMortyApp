//
//  TabBarView.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import SwiftUI

struct TabBarView: View {
    let store: StoreOf<TabBarReducer>
    
    var body: some View {
        TabView {
            CharacterListView()
                .tabItem {
                    Label("Characters", systemImage: "house")
                }
            
            CharacterFavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "house")
                }
        }
    }
}
