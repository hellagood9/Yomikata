import Foundation

extension Array where Element == Author {
    func joinedFullNames(separator: String = ", ") -> String {
        self.map { $0.fullName }.joined(separator: separator)
    }
}
