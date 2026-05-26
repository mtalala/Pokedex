//
//  PokemonSprites.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

/// Conjunto de imagens disponíveis para um Pokémon na PokeAPI.
struct PokemonSprites: Decodable {
    /// Sprite frontal padrão, quando disponível.
    let front_default: String?

    /// Outras coleções de imagens fornecidas pela API.
    let other: OtherSprites?
}

/// Agrupa coleções alternativas de sprites retornadas pela PokeAPI.
struct OtherSprites: Decodable {
    /// Arte oficial do Pokémon, usada como imagem principal na detail view.
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

/// Imagens oficiais do Pokémon em variações normal e shiny.
struct OfficialArtwork: Decodable {
    /// Arte oficial padrão.
    let frontDefault: String?

    /// Arte oficial na variação shiny, quando disponível.
    let frontShiny: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontShiny = "front_shiny"
    }
}
