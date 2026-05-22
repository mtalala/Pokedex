//
//  PokeAPIService.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation

final class PokeAPIService {

    static let shared = PokeAPIService()
    private init() {}

    func fetchRegions() async throws -> [Region] {
        let url = URL(string: "https://pokeapi.co/api/v2/region")!
        let (data, _) = try await URLSession.shared.data(from: url)

        struct Response: Codable {
            let results: [NamedAPIResource]
        }

        let decoded = try JSONDecoder().decode(Response.self, from: data)

        return decoded.results.enumerated().map {
            Region(id: $0.offset + 1, name: $0.element.name.capitalized)
        }
    }

    func fetchPokemonByRegion(regionID: Int) async throws -> [Pokemon] {
        let url = URL(string: "https://pokeapi.co/api/v2/region/\(regionID)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        struct Response: Codable {
            let pokedexes: [PokedexEntry]
        }

        struct PokedexEntry: Codable {
            let name: String
        }

        let decoded = try JSONDecoder().decode(Response.self, from: data)

        let pokedexName = decoded.pokedexes.first!.name
        return try await fetchPokemonByPokedex(name: pokedexName)
    }

    private func fetchPokemonByPokedex(name: String) async throws -> [Pokemon] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokedex/\(name)")!
        let (data, _) = try await URLSession.shared.data(from: url)

        struct Response: Codable {
            let pokemon_entries: [Entry]
        }

        struct Entry: Codable {
            let entry_number: Int
            let pokemon_species: NamedAPIResource
        }

        let decoded = try JSONDecoder().decode(Response.self, from: data)

        return decoded.pokemon_entries.map {
            Pokemon(
                id: $0.entry_number,
                name: $0.pokemon_species.name.capitalized,
                imageURL: URL(string:
                    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\($0.entry_number).png"
                )!
            )
        }
    }

    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(PokemonDetail.self, from: data)
    }
}

struct NamedAPIResource: Codable {
    let name: String
}