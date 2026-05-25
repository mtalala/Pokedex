//
//  RegionDetailResponse.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation

struct RegionDetailResponse: Decodable {
    let pokedexes: [NamedAPIResource]
}

struct Pokedex: Decodable {
    let pokemon_entries: [PokemonEntry]
}

struct PokemonEntry: Decodable, Identifiable {
    let entry_number: Int
    let pokemon_species: NamedAPIResource

    var id: Int { entry_number }
}

extension PokemonEntry {

    static let placeholder = PokemonEntry(
        entry_number: -1,
        pokemon_species: NamedAPIResource(
            name: "",
            url: ""
        )
    )

    var isPlaceholder: Bool {
        entry_number == -1
    }
}
