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

    @Published var pokemons: [PokemonEntry] = []
    @Published var regions: [Region] = []
    @Published var isLoading = false

    func load(regionName: String) async {
        isLoading = true

        pokemons = Array(repeating: .placeholder, count: 12)

        do {
            let result = try await PokeAPIService.shared.fetchPokemonsByRegion(regionName: regionName)
            pokemons = result
        } catch {
            print("Pokemons error:", error)
        }

        isLoading = false
    }

    func loadRegionsIfNeeded() async {
        if !regions.isEmpty { return }

        do {
            regions = try await PokeAPIService.shared.fetchRegions()
        } catch {
            print("Regions error:", error)
        }
    }
}
