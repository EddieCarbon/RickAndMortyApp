//
//  RMError.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import Foundation

enum HTTPError: Error, Equatable {
    case invalidURL
    case networkError(String)
    case decodingError(String)
    case serverError(Int)
    case unexpectedResponse
    case rateLimitExceeded
    case emptyResponse
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .networkError(let message):
            return "Network error: \(message)"
        case .decodingError(let message):
            return "Failed to decode response: \(message)"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .unexpectedResponse:
            return "Received unexpected response from server"
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .emptyResponse:
            return "Server returned an empty response"
        }
    }
}
