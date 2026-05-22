import SwiftUI

struct CapturePokemonSheet: View {
    let pokemons: [Pokemon]

    @Environment(PokedexStore.self) private var pokedex
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List(pokemons) { pokemon in
            Button {
                pokedex.capture(pokemonID: pokemon.id)
                dismiss()
            } label: {
                HStack {
                    Text(pokemon.name)
                    Spacer()
                    if pokedex.isCaptured(pokemon.id) {
                        Image(systemName: "checkmark")
                    }
                }
            }
            .disabled(pokedex.isCaptured(pokemon.id))
        }
        .navigationTitle("Capture Pokémon")
    }
}