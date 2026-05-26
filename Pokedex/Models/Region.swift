//
//  Region.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

/// Resposta da PokeAPI para a listagem de regiões.
struct RegionResponse: Decodable {
    /// Regiões disponíveis retornadas pela API.
    let results: [Region]
}

/// Região do universo Pokémon, como Kanto, Johto ou Hoenn.
struct Region: Decodable, Identifiable {
    /// Nome da região.
    let name: String

    /// URL do recurso correspondente na PokeAPI.
    let url: String

    /// Identificador usado pelo SwiftUI, baseado no nome da região.
    var id: String { name }
}
