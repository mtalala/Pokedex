//
//  PokedexResponse.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


/// Resposta da PokeAPI para uma Pokédex específica.
///
/// Ela contém as entradas regionais de Pokémon usadas para montar a grade principal da aplicação.
struct PokedexResponse: Decodable {
    /// Lista de entradas de Pokémon presentes na Pokédex consultada.
    let pokemon_entries: [PokemonEntry]
}
