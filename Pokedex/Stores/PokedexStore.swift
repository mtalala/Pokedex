//
//  PokedexStore.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import SwiftUI
import Observation

/// Store em memória para controlar Pokémon capturados durante uma sessão.
///
/// Embora a persistência principal do app use SwiftData, este tipo oferece uma forma simples
/// de representar uma coleção observável de capturas.
@Observable
final class PokedexStore {
    /// Conjunto de Pokémon marcados como capturados.
    var captured: Set<Pokemon> = []

    /// Adiciona um Pokémon à coleção capturada.
    func capture(_ pokemon: Pokemon) {
        captured.insert(pokemon)
    }

    /// Verifica se um Pokémon já está presente na coleção capturada.
    func isCaptured(_ pokemon: Pokemon) -> Bool {
        captured.contains(pokemon)
    }
}
