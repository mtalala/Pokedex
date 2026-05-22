//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon
    let captured: Bool

    var body: some View {
        VStack {
            AsyncImage(url: pokemon.imageURL)
                .frame(width: 80, height: 80)

            Text(pokemon.name)
                .font(.caption)

            if captured {
                Image(systemName: "checkmark.seal.fill")
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}