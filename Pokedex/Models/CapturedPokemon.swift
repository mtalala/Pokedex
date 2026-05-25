import SwiftData
import Foundation

@Model
final class CapturedPokemon {

    @Attribute(.unique) var id: Int
    var name: String
    var imageURL: String
    var capturedAt: Date

    init(id: Int, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.capturedAt = Date()
    }
}