import Foundation

extension Bundle {
    func decode<T: Codable>(_ type: T.Type, from filename: String) -> T? {
        guard let url = self.url(forResource: filename, withExtension: nil)
        else {
            return nil
        }

        guard let data = try? Data(contentsOf: url) else {
            return nil
        }

        return try? JSONDecoder().decode(type, from: data)
    }
}
