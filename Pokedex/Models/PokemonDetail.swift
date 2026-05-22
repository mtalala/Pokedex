//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonTypeEntry]
}

struct PokemonTypeEntry: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}