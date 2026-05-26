//
//  RegionDetailResponse.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation

/// Resposta detalhada de uma região, incluindo suas Pokédexes associadas.
struct RegionDetailResponse: Decodable {
    /// Pokédexes vinculadas à região consultada.
    let pokedexes: [NamedAPIResource]
}

/// Modelo de uma Pokédex contendo suas entradas de Pokémon.
struct Pokedex: Decodable {
    /// Entradas de Pokémon presentes nessa Pokédex.
    let pokemon_entries: [PokemonEntry]
}

/// Entrada de um Pokémon dentro de uma Pokédex regional.
struct PokemonEntry: Decodable, Identifiable {
    /// Número do Pokémon na Pokédex consultada.
    let entry_number: Int

    /// Recurso que identifica a espécie do Pokémon.
    let pokemon_species: NamedAPIResource

    /// Identificador usado pelo SwiftUI para renderizar listas e grades.
    var id: Int { entry_number }
}

extension PokemonEntry {

    /// Entrada temporária usada para representar cartões de carregamento.
    static let placeholder = PokemonEntry(
        entry_number: -1,
        pokemon_species: NamedAPIResource(
            name: "",
            url: ""
        )
    )

    /// Indica se a entrada é apenas um placeholder de carregamento.
    var isPlaceholder: Bool {
        entry_number == -1
    }
}
