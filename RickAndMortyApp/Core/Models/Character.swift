//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import Foundation

struct CharactersResult: Codable, Equatable {
    let info: PaginationInfo
    let results: [Character]
}

struct Character: Codable, Identifiable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

extension Character: Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}

struct Location: Codable {
    let name: String
    let url: String
}
