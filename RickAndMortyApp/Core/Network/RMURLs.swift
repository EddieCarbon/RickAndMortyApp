//
//  RMURLs.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import Foundation

enum RMURLs {
    case characters
    case episode(Int)
    case character(Int)
    
    var url: String {
        switch self {
        case .characters:
            return APIConstant.host + "character"
        case .episode(let id):
            return APIConstant.host + "episode/\(id)"
        case .character(let id):
            return APIConstant.host + "character/\(id)"
        }
    }
    
    var asURL: URL? {
        return URL(string: url)
    }
}

enum APIConstant {
    static let host = "https://rickandmortyapi.com/api/"
}
