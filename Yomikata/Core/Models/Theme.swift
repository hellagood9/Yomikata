import Foundation

struct Theme: Codable, Identifiable, Hashable {
    let id: String
    let theme: String
    
    var displayName: String {
        return theme
    }
}
