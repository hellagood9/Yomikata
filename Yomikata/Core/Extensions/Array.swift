import Foundation

extension Array {
    func joinedStringValues(
        separator: String = ", ",
        keyPath: KeyPath<Element, String>
    ) -> String {
        self.map { $0[keyPath: keyPath] }.joined(separator: separator)
    }
}
