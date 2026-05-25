//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI

struct PokemonCardView: View {

    let pokemonName: String?
    let index: Int?
    let isLoading: Bool

    var body: some View {
        VStack(spacing: 8) {

            ZStack {
                if isLoading {
                    SkeletonRectangle()
                        .frame(width: 80, height: 80)
                } else if let index {
                    AsyncImage(
                        url: URL(
                            string:
                                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index).png"
                        )
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        SkeletonRectangle()
                    }
                    .frame(width: 80, height: 80)
                }
            }

            if isLoading {
                SkeletonRectangle()
                    .frame(width: 60, height: 10)
            } else if let pokemonName {
                Text(pokemonName.capitalized)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
    }
}
