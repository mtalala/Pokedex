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

    /// Opacidade aplicada ao sprite e ao estado visual superior.
    let spriteOpacity: Double

    /// Opacidade aplicada à etiqueta do nome.
    let labelOpacity: Double

    /// Tipos carregados para o Pokémon exibido.
    @State private var types: [PokemonTypeEntry] = []

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
            .opacity(spriteOpacity)
            .task(id: index) {
                guard let index, !isLoading else {
                    types = []
                    return
                }

                do {
                    let detail = try await PokeAPIService.shared.fetchPokemonDetail(id: index)
                    types = detail.types
                } catch {
                    types = []
                }
            }

            if isLoading {
                SkeletonRectangle()
                    .frame(width: 60, height: 10)
            } else if let pokemonName {
                if !types.isEmpty {
                    HStack(spacing: 4) {
                        ForEach(types, id: \.slot) { type in
                            Circle()
                                .fill(pokemonTypeColor(for: type.type.name))
                                .frame(width: 8, height: 8)
                        }
                    }
                }

                Text(pokemonName.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.accentColor)
                    )
                    .opacity(labelOpacity)
                    .lineLimit(1)
            }
        }
    }

    /// Retorna uma cor representativa para cada tipo elemental.
    private func pokemonTypeColor(for type: String) -> Color {
        switch type.lowercased() {
        case "normal": .brown.opacity(0.65)
        case "fire": .orange
        case "water": .blue
        case "electric": .yellow
        case "grass": .green
        case "ice": .cyan
        case "fighting": .red
        case "poison": .purple
        case "ground": .brown
        case "flying": .indigo.opacity(0.75)
        case "psychic": .pink
        case "bug": .mint
        case "rock": .gray
        case "ghost": .indigo
        case "dragon": .teal
        case "dark": .black.opacity(0.75)
        case "steel": .secondary
        case "fairy": .pink.opacity(0.75)
        default: .gray
        }
    }
}
