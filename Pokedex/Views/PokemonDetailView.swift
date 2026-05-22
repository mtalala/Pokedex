//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon

    @StateObject private var vm = PokemonDetailViewModel()
    @Environment(PokedexStore.self) private var pokedex

    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: pokemon.imageURL)

            Text(pokemon.name)
                .font(.title)

            if let detail = vm.detail {
                Text("Height: \(detail.height)")
                Text("Weight: \(detail.weight)")
                Text("Types: \(detail.types.map { $0.type.name }.joined(separator: ", "))")
            }

            Button {
                pokedex.capture(pokemonID: pokemon.id)
            } label: {
                Text(pokedex.isCaptured(pokemon.id) ? "Captured" : "Capture")
            }
            .disabled(pokedex.isCaptured(pokemon.id))
        }
        .padding()
        .task {
            await vm.load(id: pokemon.id)
        }
    }
}