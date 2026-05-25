//
//  RegionPokemonView.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import SwiftUI
import SwiftData

struct RegionPokemonView: View {

    var region: Region
    @StateObject private var vm = RegionPokemonViewModel()
    @Query private var captured: [CapturedPokemon]

    @State private var selectedRegionName: String
    @State private var searchText = ""

    init(region: Region) {
        self.region = region
        _selectedRegionName = State(initialValue: region.name)
    }

    private var capturedSet: Set<Int> {
        Set(captured.map { $0.id })
    }

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
                                isLoading: true
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
                                    isLoading: false
                                )
                                .opacity(isCaptured ? 1.0 : 0.3)
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
