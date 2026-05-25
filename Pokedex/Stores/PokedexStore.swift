//
//  PokedexStore.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import SwiftUI
import Observation

@Observable
final class PokedexStore {
    var captured: Set<Pokemon> = []

    func capture(_ pokemon: Pokemon) {
        captured.insert(pokemon)
    }

    func isCaptured(_ pokemon: Pokemon) -> Bool {
        captured.contains(pokemon)
    }
}
