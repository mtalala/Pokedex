//
//  CapturedPokemon.swift
//  Pokedex
//
//  Created by mtalala on 5/25/26.
//


import SwiftData
import Foundation

/// Registro local de um Pokémon capturado pelo usuário.
///
/// Esse modelo é persistido com SwiftData e permite que o aplicativo reconheça quais Pokémon
/// já fazem parte da coleção capturada.
@Model
final class CapturedPokemon {

    /// Nome único do Pokémon capturado.
    @Attribute(.unique)
    var name: String

    /// Identificador oficial do Pokémon na PokeAPI.
    var id: Int

    /// Endereço da imagem usada para representar o Pokémon capturado.
    var imageURL: String

    /// Cria um novo registro persistente de captura.
    init(name: String, id: Int, imageURL: String) {
        self.name = name
        self.id = id
        self.imageURL = imageURL
    }
}
