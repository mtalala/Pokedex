//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

/// Informações detalhadas de um Pokémon específico.
///
/// Esse modelo alimenta a detail view, reunindo dados físicos, tipos e imagens oficiais.
struct PokemonDetail: Decodable {
    /// Identificador oficial do Pokémon.
    let id: Int

    /// Nome do Pokémon.
    let name: String

    /// Altura informada pela PokeAPI.
    let height: Int

    /// Peso informado pela PokeAPI.
    let weight: Int

    /// Tipos associados ao Pokémon, como fogo, água ou elétrico.
    let types: [PokemonTypeEntry]

    /// Sprites e artes disponíveis para exibição.
    let sprites: PokemonSprites?
}

/// Entrada que associa um tipo à sua posição na lista de tipos do Pokémon.
struct PokemonTypeEntry: Decodable {
    /// Ordem do tipo na resposta da API.
    let slot: Int

    /// Tipo propriamente dito.
    let type: PokemonType
}

/// Tipo elemental de um Pokémon.
struct PokemonType: Decodable {
    /// Nome do tipo.
    let name: String

    /// URL do recurso completo na PokeAPI.
    let url: String
}
