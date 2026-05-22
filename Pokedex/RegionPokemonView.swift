import SwiftUI

struct RegionPokemonView: View {
    let region: Region

    @StateObject private var vm = RegionPokemonViewModel()
    @Environment(PokedexStore.self) private var pokedex
    @State private var showCapture = false

    let columns = [GridItem(.adaptive(minimum: 100))]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(vm.pokemons) { pokemon in
                    NavigationLink {
                        PokemonDetailView(pokemon: pokemon)
                    } label: {
                        PokemonCardView(
                            pokemon: pokemon,
                            captured: pokedex.isCaptured(pokemon.id)
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle(region.name)
        .toolbar {
            Button {
                showCapture = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showCapture) {
            CapturePokemonSheet(pokemons: vm.pokemons)
        }
        .task {
            await vm.load(regionID: region.id)
        }
    }
}