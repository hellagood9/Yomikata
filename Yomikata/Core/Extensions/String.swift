import Foundation

extension String {
    func localized(fallback: String? = nil) -> String {
        let value = NSLocalizedString(self, comment: "")
        return value == self ? (fallback ?? self) : value
    }
}

extension String {
    var localizedGenre: String {
        let key = "genre.\(self.lowercased().replacingOccurrences(of: " ", with: "_"))"
        return key.localized(fallback: self)
    }
}
