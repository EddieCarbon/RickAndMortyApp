//
//  URLSession+Extensions.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 08/05/2025.
//

import Foundation

extension URLSession {
    static func validateData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try validateHttpResponse(response)
        
        if data.isEmpty {
            throw HTTPError.emptyResponse
        }
        
        return data
    }
    
    private static func validateHttpResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPError.unexpectedResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 429:
            throw HTTPError.rateLimitExceeded
        case 400...599:
            throw HTTPError.serverError(httpResponse.statusCode)
        default:
            throw HTTPError.unexpectedResponse
        }
    }
}
