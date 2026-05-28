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

    /// Pokémon aguardando confirmação de captura.
    @State private var pendingCapture: CaptureContext?

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
        .fullScreenCover(item: $pendingCapture) { captureContext in
            CaptureView(
                pokemonName: captureContext.name,
                pokemonSpriteURL: captureContext.spriteURL,
                onBack: {
                    pendingCapture = nil
                },
                onCapture: {
                    capture(captureContext.detail)
                    pendingCapture = nil
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

            HStack(spacing: 12) {
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

            combatStatsSection(detail.stats)
            Button(isCaptured ? "Captured" : "Capture") {
                guard !isCaptured else { return }

                pendingCapture = CaptureContext(
                    id: detail.id,
                    name: detail.name,
                    spriteURL: captureSpriteURL(for: detail),
                    detail: detail
                )
            }
            .buttonStyle(isCaptured ? .glass(.regular) : .glass(.regular.tint(.blue)))
            .foregroundStyle(isCaptured ? Color.gray.opacity(0.75) : .white)
        }
        .padding()
    }

    /// Mostra os atributos de combate em cartões organizados em grade.
    private func combatStatsSection(_ stats: [PokemonStatEntry]) -> some View {
        let displayStats = stats.sorted { statOrder($0.stat.name) < statOrder($1.stat.name) }

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)

                Text("Combat Stats")
                    .font(.headline.weight(.bold))
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                ForEach(Array(displayStats.enumerated()), id: \.offset) { _, stat in
                    combatStatCard(stat)
                }
            }
        }
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
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    /// Cria um cartão para um atributo de combate individual.
    private func combatStatCard(_ stat: PokemonStatEntry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(formattedStatName(stat.stat.name))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Text("\(stat.baseStat)")
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            if stat.effort > 0 {
                Text("EV +\(stat.effort)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .padding(12)
        .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    /// Deixa os nomes de stats mais legíveis para exibição.
    private func formattedStatName(_ name: String) -> String {
        switch name.lowercased() {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default:
            return name.replacingOccurrences(of: "-", with: " ").capitalized
        }
    }

    /// Mantém a ordem clássica dos atributos base da PokéAPI.
    private func statOrder(_ name: String) -> Int {
        switch name.lowercased() {
        case "hp": return 0
        case "attack": return 1
        case "defense": return 2
        case "special-attack": return 3
        case "special-defense": return 4
        case "speed": return 5
        default: return 99
        }
    }

    /// Dados estáveis usados para apresentar a experiência de captura.
    private struct CaptureContext: Identifiable {
        let id: Int
        let name: String
        let spriteURL: URL?
        let detail: PokemonDetail
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
    private func captureSpriteURL(for detail: PokemonDetail) -> URL? {
        let urlString = detail.sprites?.other?.officialArtwork?.frontDefault ?? detail.sprites?.front_default
        guard let urlString, !urlString.isEmpty else { return nil }
        return URL(string: urlString)
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
