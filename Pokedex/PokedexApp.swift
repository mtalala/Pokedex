//
//  PokedexApp.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

/// Ponto de entrada do aplicativo Pokedex.
///
/// Esta estrutura configura a janela principal e registra o container SwiftData usado para salvar capturas.
@main
struct PokedexApp: App {

    /// Cena principal exibida pelo aplicativo.
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CapturedPokemon.self)
    }
}
