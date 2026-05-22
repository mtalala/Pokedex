import Foundation

struct RegionDetailResponse: Decodable {
    let pokedexes: [Pokedex]
}

struct Pokedex: Decodable {
    let pokemon_entries: [PokemonEntry]
}

struct PokemonEntry: Decodable, Identifiable {
    let entry_number: Int
    let pokemon_species: NamedAPIResource

    var id: Int { entry_number }
}