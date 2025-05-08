//
//  RMURLs.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import Foundation

enum RMURLs {
    case characters(_ page: Int? = nil)
    case episode(Int)
    case character(Int)
    
    var url: String {
        switch self {
        case .characters(let page):
            if let page = page {
                return APIConstant.host + "character?page=\(page)"
            } else {
                return APIConstant.host + "character"
            }
        case .episode(let id):
            return APIConstant.host + "episode/\(id)"
        case .character(let id):
            return APIConstant.host + "character/\(id)"
        }
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: self.url) else {
            throw HTTPError.invalidURL
        }
        return url
    }
}

enum APIConstant {
    static let host = "https://rickandmortyapi.com/api/"
}
