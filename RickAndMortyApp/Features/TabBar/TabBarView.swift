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
            CharactersListView(store: <#T##StoreOf<CharactersListReducer>#>)
                .tabItem {
                    Label("Characters", systemImage: "house")
                }
            
            FavouritesCharactesView(store: <#T##StoreOf<CharacterFavouritesReducer>#>)
                .tabItem {
                    Label("Favourites", systemImage: "house")
                }
        }
    }
}
