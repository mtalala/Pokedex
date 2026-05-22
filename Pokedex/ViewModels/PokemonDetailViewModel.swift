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

    func load(id: Int) async {
        isLoading = true
        defer { isLoading = false }

        do {
            detail = try await PokeAPIService.shared.fetchPokemonDetail(id: id)
        } catch {
            print(error)
        }
    }
}
