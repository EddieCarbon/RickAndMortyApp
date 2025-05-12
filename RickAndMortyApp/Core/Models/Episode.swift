//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import Foundation

struct Episode: Codable, Equatable, Identifiable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}
