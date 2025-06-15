import Foundation

struct Genre: Codable, Identifiable, Hashable {
    let id: String
    let genre: String
    
    var displayName: String {
        return genre
    }
}
