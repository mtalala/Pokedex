//
//  NamedAPIResource.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

/// Recurso nomeado no formato comum usado pela PokeAPI.
///
/// Muitas respostas da API indicam entidades relacionadas por meio de um nome e uma URL.
/// Esse modelo centraliza essa representação.
struct NamedAPIResource: Decodable {
    /// Nome do recurso.
    let name: String

    /// URL que aponta para os dados completos do recurso.
    let url: String
}

extension NamedAPIResource {

    /// Identificador numérico extraído da URL do recurso.
    var idFromURL: Int {
        guard let last = URL(string: url)?
            .pathComponents
            .last else {
            return 0
        }

        return Int(last) ?? 0
    }
}
