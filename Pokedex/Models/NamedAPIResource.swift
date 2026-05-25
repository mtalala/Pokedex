//
//  NamedAPIResource.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

struct NamedAPIResource: Decodable {
    let name: String
    let url: String
}

extension NamedAPIResource {

    var idFromURL: Int {
        guard let last = URL(string: url)?
            .pathComponents
            .last else {
            return 0
        }

        return Int(last) ?? 0
    }
}
