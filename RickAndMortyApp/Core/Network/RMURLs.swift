//
//  RMURLs.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import Foundation

enum RMURLs {
    case characters(_ page: Int = 1)
    case episodes([Int])
    case character(Int)
    
    var url: String {
        switch self {
        case .characters(let page):
            return APIConstant.host + "character?page=\(page)"
        case .episodes(let ids):
            let idsString = ids.map { String($0) }.joined(separator: ",")
            return APIConstant.host + "episode/\(idsString)"
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
