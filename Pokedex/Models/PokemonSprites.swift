//
//  PokemonSprites.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

struct PokemonSprites: Decodable {
    let front_default: String?
    let other: OtherSprites?
}

struct OtherSprites: Decodable {
    let officialArtwork: OfficialArtwork?

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Decodable {
    let frontDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
