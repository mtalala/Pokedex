//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

struct PokemonDetailView: View {

    let pokemonName: String

    @StateObject private var vm = PokemonDetailViewModel()
    @Environment(\.modelContext) private var context
    @Query private var captured: [CapturedPokemon]

    @State private var showCapture = false
    @State private var pending: PokemonDetail?
    @State private var showsShinySprite = false

    private var capturedSet: Set<Int> {
        Set(captured.map { $0.id })
    }

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
            CaptureView {
                if let detail = pending {
                    capture(detail)
                }

                pending = nil
                showCapture = false
            }
        }
    }

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
            .buttonStyle(.bordered)

            Text("#\(detail.id)")
                .foregroundColor(.secondary)

            HStack {
                ForEach(detail.types, id: \.slot) { t in
                    Text(t.type.name.capitalized)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }

            VStack(alignment: .leading) {
                Text("Height: \(detail.height)")
                Text("Weight: \(detail.weight)")
            }

            Button(isCaptured ? "Captured" : "Capture") {
                pending = detail
                showCapture = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(isCaptured)
        }
        .padding()
    }

    private var skeletonContent: some View {
        ProgressView()
            .padding()
    }

    private func spriteURL(for detail: PokemonDetail) -> String {
        let artwork = detail.sprites?.other?.officialArtwork

        if showsShinySprite {
            return artwork?.frontShiny ?? artwork?.frontDefault ?? ""
        }

        return artwork?.frontDefault ?? ""
    }

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
