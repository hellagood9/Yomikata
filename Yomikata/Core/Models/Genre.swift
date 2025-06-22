import Foundation

struct Genre: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let genre: String
    
    var displayName: String {
        return genre
    }
}
