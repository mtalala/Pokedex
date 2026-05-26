//
//  ContentView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

/// Tela inicial do aplicativo.
///
/// Atualmente ela abre a navegação principal a partir da região de Kanto.
struct ContentView: View {
    /// Conteúdo visual inicial do app.
    var body: some View {
        RegionPokemonView(region: .init(name: "kanto", url: "https://pokeapi.co/api/v2/region/1/"))
    }
}
#Preview {
    NavigationStack {
        ContentView()
    }
    .modelContainer(for: CapturedPokemon.self, inMemory: true)
}
