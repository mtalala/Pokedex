//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

/// Informações detalhadas de um Pokémon específico.
///
/// Esse modelo alimenta a detail view, reunindo dados físicos, tipos,
/// movimentos, atributos de combate e imagens oficiais.
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

    /// Atributos base de combate (HP, Attack, Defense, Speed, etc.).
    let stats: [PokemonStatEntry]

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

/// Entrada que representa um atributo base de combate.
struct PokemonStatEntry: Decodable {
    /// Valor base do atributo (ex: HP = 45).
    let baseStat: Int

    /// Esforço concedido ao derrotar o Pokémon (EV yield).
    let effort: Int

    /// Tipo do atributo (HP, Attack, Defense, etc.).
    let stat: PokemonStat

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

/// Tipo de atributo de combate.
struct PokemonStat: Decodable {
    /// Nome do atributo (hp, attack, defense, special-attack, special-defense, speed).
    let name: String

    /// URL do recurso completo do atributo na PokeAPI.
    let url: String
}
