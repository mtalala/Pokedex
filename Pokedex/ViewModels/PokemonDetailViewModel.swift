//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation
import Combine

@MainActor
final class PokemonDetailViewModel: ObservableObject {

    @Published var detail: PokemonDetail?
    @Published var isLoading = false

    func load(name: String) async {
        print("LOAD CALLED:", name)

        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await PokeAPIService.shared.fetchPokemonDetail(name: name)
            print("SUCCESS:", result.name)
            detail = result
        } catch {
            print("ERROR:", error)
        }
    }
}
