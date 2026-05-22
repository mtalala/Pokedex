//
//  PokedexStore.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation
import Observation

@Observable
final class PokedexStore {
    private(set) var captured: Set<Int> = []

    func capture(pokemonID: Int) {
        captured.insert(pokemonID)
    }

    func isCaptured(_ pokemonID: Int) -> Bool {
        captured.contains(pokemonID)
    }
}