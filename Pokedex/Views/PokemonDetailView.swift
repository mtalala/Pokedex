//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

/// Tela de detalhes de um Pokémon selecionado.
///
/// A view apresenta informações completas, permite alternar para a imagem shiny e inicia o fluxo de captura.
struct PokemonDetailView: View {

    /// Nome usado para buscar os detalhes do Pokémon na PokeAPI.
    let pokemonName: String

    /// View model que carrega os dados detalhados.
    @StateObject private var vm = PokemonDetailViewModel()

    /// Contexto SwiftData usado para salvar capturas.
    @Environment(\.modelContext) private var context

    /// Pokémon capturados persistidos localmente.
    @Query private var captured: [CapturedPokemon]

    /// Controla a apresentação da tela de captura.
    @State private var showCapture = false

    /// Pokémon aguardando confirmação de captura.
    @State private var pending: PokemonDetail?

    /// Controla se a imagem exibida deve ser a versão shiny.
    @State private var showsShinySprite = false

    /// Conjunto de identificadores já capturados, usado para evitar capturas duplicadas.
    private var capturedSet: Set<Int> {
        Set(captured.map { $0.id })
    }

    /// Conteúdo visual da ficha do Pokémon.
    var body: some View {
        ScrollView {

            if vm.isLoading || vm.detail == nil {
                skeletonContent
            } else if let detail = vm.detail {
                content(detail)
            }
        }
        .navigationTitle(vm.detail?.name.capitalized ?? pokemonName.capitalized)
        .task {
            await vm.load(name: pokemonName)
        }
        .fullScreenCover(isPresented: $showCapture) {
            CaptureView(
                pokemonName: pending?.name ?? pokemonName,
                pokemonSpriteURL: URL(string: pending.map(captureSpriteURL(for:)) ?? ""),
                onBack: {
                    pending = nil
                    showCapture = false
                },
                onCapture: {
                    if let detail = pending {
                        capture(detail)
                    }

                    pending = nil
                    showCapture = false
                }
            )
        }
    }

    /// Monta o conteúdo principal quando os detalhes do Pokémon já foram carregados.
    private func content(_ detail: PokemonDetail) -> some View {

        let isCaptured = capturedSet.contains(detail.id)

        return VStack(spacing: 20) {

            AsyncImage(
                url: URL(string: spriteURL(for: detail))
            ) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)

            Button {
                showsShinySprite.toggle()
            } label: {
                Label(showsShinySprite ? "Normal" : "Shiny", systemImage: showsShinySprite ? "circle" : "sparkles")
            }
            .buttonStyle(.glass(.regular.tint(.blue)))
            .foregroundStyle(.white)

            Text("#\(detail.id)")
                .foregroundColor(.secondary)

            HStack {
                ForEach(detail.types, id: \.slot) { t in
                    let typeColor = pokemonTypeColor(for: t.type.name)

                    Text(t.type.name.capitalized)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(typeColor)
                        .clipShape(Capsule())
                }
            }

            VStack(spacing: 12) {
                metricCard(
                    title: "Height",
                    value: "\(detail.height)",
                    systemImage: "ruler"
                )

                metricCard(
                    title: "Weight",
                    value: "\(detail.weight)",
                    systemImage: "scalemass"
                )
            }

            Button(isCaptured ? "Captured" : "Capture") {
                pending = detail
                showCapture = true
            }
            .buttonStyle(.glass(.regular.tint(.blue)))
            .foregroundStyle(.white)
            .disabled(isCaptured)
        }
        .padding()
    }

    /// Conteúdo temporário apresentado enquanto os detalhes estão carregando.
    private var skeletonContent: some View {
        ProgressView()
            .padding()
    }

    /// Cria um cartão visual para exibir métricas do Pokémon.
    private func metricCard(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)

                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
            }

            Text(value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.blue.opacity(0.18), lineWidth: 1)
        )
    }

    /// Escolhe a URL da imagem normal ou shiny de acordo com o estado da view.
    private func spriteURL(for detail: PokemonDetail) -> String {
        let artwork = detail.sprites?.other?.officialArtwork

        if showsShinySprite {
            return artwork?.frontShiny ?? artwork?.frontDefault ?? ""
        }

        return artwork?.frontDefault ?? ""
    }

    /// Escolhe a arte oficial para a tela de captura.
    private func captureSpriteURL(for detail: PokemonDetail) -> String {
        detail.sprites?.other?.officialArtwork?.frontDefault ?? detail.sprites?.front_default ?? ""
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

    /// Salva o Pokémon capturado no armazenamento local com SwiftData.
    private func capture(_ detail: PokemonDetail) {

        let new = CapturedPokemon(
            name: detail.name, id: detail.id,
            imageURL: detail.sprites?.other?.officialArtwork?.frontDefault ?? ""
        )

        print("INSERTING:", new.id, new.name)

        context.insert(new)

        DispatchQueue.main.async {
            do {
                try context.save()
                print("SAVE OK")
            } catch {
                print("SAVE FAILED:", error)
            }
        }
    }
}
