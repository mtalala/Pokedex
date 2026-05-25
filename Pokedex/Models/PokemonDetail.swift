//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

struct PokemonDetail: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites?
}

struct PokemonTypeEntry: Decodable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Decodable {
    let name: String
    let url: String
}
