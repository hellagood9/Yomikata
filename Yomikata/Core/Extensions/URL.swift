import Foundation

extension URL {
    var cleaned: URL? {
        let cleanedString = self.absoluteString.replacingOccurrences(
            of: "\"", with: "")
        return URL(string: cleanedString)
    }
}
