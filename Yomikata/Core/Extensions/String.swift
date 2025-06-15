import Foundation

extension String {
    func localized(fallback: String? = nil) -> String {
        let value = NSLocalizedString(self, comment: "")
        return value == self ? (fallback ?? self) : value
    }
}
