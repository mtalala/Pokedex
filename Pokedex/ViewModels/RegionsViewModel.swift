//
//  RegionsViewModel.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation
import Combine

@MainActor
final class RegionsViewModel: ObservableObject {
    @Published var regions: [Region] = []
    @Published var isLoading = false

    func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            regions = try await PokeAPIService.shared.fetchRegions()
        } catch {
            print(error)
        }
    }
}
