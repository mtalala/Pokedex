//
//  RegionsViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import SwiftUI
import Combine

/// View model responsável por carregar as regiões disponíveis na PokeAPI.
@MainActor
final class RegionsViewModel: ObservableObject {
    /// Lista de regiões disponíveis para navegação.
    @Published var regions: [Region] = []

    /// Indica se as regiões ainda estão sendo carregadas.
    @Published var isLoading = false

    /// Busca as regiões e atualiza o estado observado pela interface.
    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            regions = try await PokeAPIService.shared.fetchRegions()
        } catch {
            print("ERROR loading regions:", error)
        }
    }
}
