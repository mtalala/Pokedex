//
//  PokeAPIService.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

//
//  PokeAPIService.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

enum PokeAPIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}

final class PokeAPIService {

    static let shared = PokeAPIService()
    private init() {}

    private let baseURL = "https://pokeapi.co/api/v2"

    private func request<T: Decodable>(_ url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw PokeAPIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw PokeAPIError.decodingError
        }
    }

    func fetchRegions() async throws -> [Region] {
        guard let url = URL(string: "\(baseURL)/region") else {
            throw PokeAPIError.invalidURL
        }

        let response: RegionResponse = try await request(url)
        return response.results
    }

    private func pokedexName(for region: String) -> String {
        switch region.lowercased() {
        case "kanto": return "kanto"
        case "johto": return "original-johto"
        case "hoenn": return "hoenn"
        case "sinnoh": return "original-sinnoh"
        case "unova": return "original-unova"
        case "kalos": return "kalos"
        case "alola": return "original-alola"
        case "galar": return "galar"
        default: return "kanto"
        }
    }

    func fetchPokemonsByRegion(regionName: String) async throws -> [PokemonEntry] {

        let pokedex = pokedexName(for: regionName)

        guard let url = URL(string: "\(baseURL)/pokedex/\(pokedex)") else {
            throw PokeAPIError.invalidURL
        }

        let response: PokedexResponse = try await request(url)

        return response.pokemon_entries
            .sorted { $0.entry_number < $1.entry_number }
    }

    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        guard let url = URL(string: "\(baseURL)/pokemon/\(id)") else {
            throw PokeAPIError.invalidURL
        }

        return try await request(url)
    }

    func fetchPokemonDetail(name: String) async throws -> PokemonDetail {
        guard let url = URL(string: "\(baseURL)/pokemon/\(name.lowercased())") else {
            throw PokeAPIError.invalidURL
        }

        return try await request(url)
    }
}
