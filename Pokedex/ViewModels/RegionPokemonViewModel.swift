//
//  RegionPokemonViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation
import Combine

/// View model principal da view regional de Pokémon.
///
/// Ele carrega tanto a lista de regiões quanto os Pokémon da região selecionada,
/// coordenando os estados que aparecem na grade principal.
@MainActor
final class RegionPokemonViewModel: ObservableObject {

    /// Pokémon exibidos na região atual.
    @Published var pokemons: [PokemonEntry] = []

    /// Regiões disponíveis no menu de seleção.
    @Published var regions: [Region] = []

    /// Indica se a lista regional está em carregamento.
    @Published var isLoading = false

    /// Carrega os Pokémon da região selecionada e exibe placeholders enquanto aguarda a resposta.
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

    /// Carrega as regiões apenas quando elas ainda não foram obtidas.
    func loadRegionsIfNeeded() async {
        if !regions.isEmpty { return }

        do {
            regions = try await PokeAPIService.shared.fetchRegions()
        } catch {
            print("Regions error:", error)
        }
    }
}
