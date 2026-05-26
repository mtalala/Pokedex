//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Combine
import SwiftUI

/// View model para carregar uma lista de Pokémon por região.
///
/// Esse tipo mantém o estado de carregamento e entrega uma lista pronta para uso pela interface.
@MainActor
final class PokemonListViewModel: ObservableObject {

    /// Pokémon retornados para a região consultada.
    @Published var pokemons: [PokemonEntry] = []

    /// Indica se a listagem está sendo carregada.
    @Published var isLoading = false

    /// Carrega os Pokémon de uma região específica.
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
