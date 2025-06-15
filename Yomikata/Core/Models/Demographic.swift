import Foundation

struct Demographic: Codable, Identifiable, Hashable {
    let id: String
    let demographic: String

    var displayName: String {
        let label =
            demographic.prefix(1).capitalized
            + demographic.dropFirst().lowercased()

        let translated = NSLocalizedString(demographic, comment: "")

        return "\(label) \(translated)"
    }
}
