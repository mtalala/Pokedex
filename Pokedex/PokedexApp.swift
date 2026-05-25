//
//  PokedexApp.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

@main
struct PokedexApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CapturedPokemon.self)
    }
}
