//
//  Pokemon.swift
//  Pokedex
//
//  Created by mtalala on 5/19/26.
//


import Foundation

struct Pokemon: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let imageURL: URL
}