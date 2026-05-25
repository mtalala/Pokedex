//
//  CapturedPokemon.swift
//  Pokedex
//
//  Created by mtalala on 5/25/26.
//


import SwiftData
import Foundation

@Model
final class CapturedPokemon {

    @Attribute(.unique)
    var name: String

    var id: Int
    var imageURL: String

    init(name: String, id: Int, imageURL: String) {
        self.name = name
        self.id = id
        self.imageURL = imageURL
    }
}
