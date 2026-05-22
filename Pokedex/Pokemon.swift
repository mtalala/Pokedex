import Foundation

struct Pokemon: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let imageURL: URL
}