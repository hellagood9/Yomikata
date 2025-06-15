struct Author: Codable, Identifiable, Hashable {
    let id: String
    let firstName: String
    let lastName: String
    let role: String

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    var displayRole: String {
        switch role.lowercased() {
        case AuthorRole.storyAndArt.rawValue:
            return "story & art".localized(fallback: role)
        case AuthorRole.story.rawValue:
            return "story".localized(fallback: role)
        case AuthorRole.art.rawValue:
            return "art".localized(fallback: role)
        default:
            return role.localized()
        }
    }
}

enum AuthorRole: String, CaseIterable {
    case storyAndArt = "story & art"
    case story = "story"
    case art = "art"
}
