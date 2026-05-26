//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation
import Combine

/// View model responsável por carregar e expor os detalhes de um Pokémon.
///
/// Ele separa a lógica de busca da tela, mantendo a interface focada na apresentação dos dados.
@MainActor
final class PokemonDetailViewModel: ObservableObject {

    /// Detalhes carregados do Pokémon selecionado.
    @Published var detail: PokemonDetail?

    /// Indica se a busca de detalhes está em andamento.
    @Published var isLoading = false

    /// Carrega os detalhes de um Pokémon a partir do nome.
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
