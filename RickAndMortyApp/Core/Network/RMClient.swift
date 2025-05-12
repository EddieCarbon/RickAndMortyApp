//
//  RMClient.swift
//  RickAndMortyApp
//
//  Created by Jakub Tomiczek on 07/05/2025.
//

import ComposableArchitecture
import Foundation

struct RMClient {
    var fetchCharacters: (Int) async throws -> CharactersResult
    var fetchCharactersByUrls: ([String]) async throws -> [Character]
    var fetchEpisodesByUrls: ([String]) async throws -> [Episode]
}

extension RMClient: DependencyKey {
    static var liveValue: Self {
        return RMClient(
            fetchCharacters: { page in
                let url = try RMURLs.characters(page).asURL()
                let result: CharactersResult = try await request(url: url)
                return result
            },
            fetchCharactersByUrls: { urls in
                let characters: [Character] = try await compactArrayRequest(for: urls)
                return characters
            },
            fetchEpisodesByUrls: { urls in
                let ids = urls.compactMap { url -> Int? in
                    guard let lastComponent = URL(string: url)?.lastPathComponent else { return nil }
                    return Int(lastComponent)
                }.filter { $0 > 0 }
                
                if !ids.isEmpty {
                    let url = try RMURLs.episodes(ids).asURL()
                    switch ids.count {
                    case 1:
                        let episode: Episode = try await request(url: url)
                        return [episode]
                    default:
                        let episodes: [Episode] = try await request(url: url)
                        return episodes
                    }
                }
                return []
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
            let data = try await URLSession.validateData(from: url)
            return try decode(data: data)
        } catch {
            switch error {
            case let error as HTTPError:
                throw error
            default:
                throw HTTPError.networkError(error.localizedDescription)
            }
        }
    }
    
    static func decode<Object: Codable>(data: Data) throws -> Object {
        do {
            let decoder = JSONDecoder()
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
