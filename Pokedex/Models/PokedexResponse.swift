//
//  PokedexResponse.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


struct PokedexResponse: Decodable {
    let pokemon_entries: [PokemonEntry]
}
