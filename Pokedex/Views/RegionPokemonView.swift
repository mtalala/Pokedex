//
//  RegionPokemonView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

/// Tela principal para explorar Pokémon por região.
///
/// A view apresenta uma grade pesquisável, permite trocar a região exibida e indica visualmente
/// quais Pokémon já foram capturados pelo usuário.
struct RegionPokemonView: View {

    /// Região usada para inicializar a tela.
    var region: Region

    /// View model que carrega regiões e Pokémon.
    @StateObject private var vm = RegionPokemonViewModel()

    /// Registros persistidos de Pokémon capturados.
    @Query private var captured: [CapturedPokemon]

    /// Nome da região atualmente selecionada no menu.
    @State private var selectedRegionName: String

    /// Texto usado para filtrar Pokémon pelo nome.
    @State private var searchText = ""

    /// Cria a regional view a partir de uma região inicial.
    init(region: Region) {
        self.region = region
        _selectedRegionName = State(initialValue: region.name)
    }

    /// Conjunto de identificadores capturados, usado para atualizar a aparência dos cartões.
    private var capturedSet: Set<Int> {
        Set(captured.map { $0.id })
    }

    /// Conteúdo visual da listagem regional.
    var body: some View {
            
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 100))],
                spacing: 16
            ) {

                ForEach(vm.pokemons) { entry in

                    let name = entry.pokemon_species.name

                    if !searchText.isEmpty &&
                        !name.localizedCaseInsensitiveContains(searchText) {
                        EmptyView()
                    } else {

                        if entry.isPlaceholder {

                            PokemonCardView(
                                pokemonName: nil,
                                index: nil,
                                isLoading: true,
                                spriteOpacity: 1.0,
                                labelOpacity: 1.0
                            )

                        } else {

                            let id = entry.pokemon_species.idFromURL
                            let isCaptured = capturedSet.contains(id)

                            NavigationLink {
                                PokemonDetailView(pokemonName: name)
                            } label: {
                                PokemonCardView(
                                    pokemonName: name,
                                    index: id,
                                    isLoading: false,
                                    spriteOpacity: isCaptured ? 1.0 : 0.3,
                                    labelOpacity: isCaptured ? 1.0 : 0.7
                                )
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem {
                Menu("Regions", systemImage: "globe") {
                    Picker("Region", selection: $selectedRegionName) {
                        ForEach(vm.regions) { region in
                            Text(region.name.capitalized).tag(region.name)
                        }
                    }
                }
            }
        }
        .navigationTitle(selectedRegionName.capitalized)
        .searchable(text: $searchText)
        .task {
            await vm.loadRegionsIfNeeded()
        }
        .task(id: selectedRegionName) {
            await vm.load(regionName: selectedRegionName)
        }
    }
}
