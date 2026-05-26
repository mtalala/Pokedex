//
//  Pokemon.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation

/// Representação simples de um Pokémon dentro do aplicativo.
///
/// Esse tipo é útil quando apenas o identificador e o nome são necessários, sem carregar todos os detalhes
/// vindos da PokeAPI.
struct Pokemon: Identifiable, Hashable {
    /// Identificador numérico do Pokémon.
    let id: Int

    /// Nome do Pokémon.
    let name: String
}
