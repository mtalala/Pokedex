//
//  RegionPokemonViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation
import Combine

@MainActor
final class RegionPokemonViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var isLoading = false

    func load(regionID: Int) async {
        isLoading = true
        defer { isLoading = false }

        do {
            pokemons = try await PokeAPIService.shared.fetchPokemonByRegion(regionID: regionID)
        } catch {
            print(error)
        }
    }
}
