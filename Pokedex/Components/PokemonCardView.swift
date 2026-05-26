//
//  PokemonCardView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI

/// Cartão visual usado na grade regional para apresentar um Pokémon de forma compacta.
///
/// O componente mostra o sprite, o nome e, quando necessário, uma versão temporária de carregamento.
/// Ele ajuda a manter a listagem organizada e visualmente consistente.
struct PokemonCardView: View {

    /// Nome do Pokémon exibido no cartão.
    let pokemonName: String?

    /// Identificador usado para buscar o sprite público do Pokémon.
    let index: Int?

    /// Indica se o cartão deve mostrar o estado de carregamento.
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
                                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(index).png"
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
