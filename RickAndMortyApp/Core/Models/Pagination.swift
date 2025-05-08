//
//  Pagination.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 08/05/2025.
//

import Foundation

struct PaginationInfo: Codable, Equatable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
