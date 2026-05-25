//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Combine
import SwiftUI

@MainActor
final class PokemonListViewModel: ObservableObject {

    @Published var pokemons: [PokemonEntry] = []
    @Published var isLoading = false

    func load(regionName: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            pokemons = try await PokeAPIService.shared
                .fetchPokemonsByRegion(regionName: regionName)
        } catch {
            print(error)
        }
    }
}
