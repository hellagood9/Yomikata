import Foundation

struct Theme: Codable, Identifiable, Hashable, Sendable {
    let id: String
    let theme: String
    
    var displayName: String {
        return theme
    }
}
