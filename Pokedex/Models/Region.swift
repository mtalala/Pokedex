//
//  Region.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//

import Foundation

struct RegionResponse: Decodable {
    let results: [Region]
}

struct Region: Decodable, Identifiable {
    let name: String
    let url: String

    var id: String { name }
}
