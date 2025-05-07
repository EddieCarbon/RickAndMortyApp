//
//  RMClient.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Foundation

struct RMClient {
    var fetchAllCharacters: () async throws -> [Character]
    var fetchCharacters: ([String]) async throws -> [Character]
    var fetchEpisodeDetails: (Int) async throws -> Episode?
}

// MARK: - Dependency Registration

extension RMClient: DependencyKey {
    static var liveValue: Self {
        return RMClient(
            fetchAllCharacters: {
                guard let url = RMURLs.characters.asURL else {
                    throw HTTPError.invalidURL
                }
                
                let result: CharactersResult = try await request(url: url)
                return result.results
            },
            fetchCharacters: { urls in
                let characters: [Character] = try await compactArrayRequest(for: urls)
                return characters
            },
            fetchEpisodeDetails: { id in
                guard let url = RMURLs.episode(id).asURL else {
                    throw HTTPError.invalidURL
                }
                
                return try await request(url: url)
            }
        )
    }
}

extension DependencyValues {
    var rmClient: RMClient {
        get { self[RMClient.self] }
        set { self[RMClient.self] = newValue }
    }
}

// MARK: - Network Request Helpers

extension RMClient {
    static func request<Object: Codable>(url: URL) async throws -> Object {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.unexpectedResponse
            }
            
            try validateHttpResponse(httpResponse)
            
            if data.isEmpty {
                throw HTTPError.emptyResponse
            }
            
            return try decode(data: data)
            
        } catch let error as HTTPError {
            throw error
        } catch {
            throw HTTPError.networkError(error.localizedDescription)
        }
    }
    
    static func validateHttpResponse(_ response: HTTPURLResponse) throws {
        switch response.statusCode {
        case 200...299:
            break
        case 429:
            throw HTTPError.rateLimitExceeded
        case 400...499:
            throw HTTPError.serverError(response.statusCode)
        case 500...599:
            throw HTTPError.serverError(response.statusCode)
        default:
            throw HTTPError.unexpectedResponse
        }
    }
    
    static func decode<Object: Codable>(data: Data) throws -> Object {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Object.self, from: data)
        } catch {
            throw HTTPError.decodingError(error.localizedDescription)
        }
    }
}

// MARK: - Batch Request Handling

extension RMClient {
    static func compactArrayRequest<Object: Codable>(for links: [String]) async throws -> [Object] {
        return try await withThrowingTaskGroup(of: Object.self) { group in
            for link in links {
                group.addTask {
                    guard let linkURL = URL(string: link) else {
                        throw HTTPError.invalidURL
                    }
                    return try await request(url: linkURL)
                }
            }
            
            return try await group.reduce(into: [Object]()) { result, item in
                result.append(item)
            }
        }
    }
}
