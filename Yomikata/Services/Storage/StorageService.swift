import Foundation

// MARK: - Protocol

protocol LocalStorageService {
    func save<T: Codable>(_ object: T, forKey key: String) -> Bool
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
    func saveArray<T: Codable>(_ array: [T], forKey key: String) -> Bool
    func loadArray<T: Codable>(_ type: T.Type, forKey key: String) -> [T]
    func delete(forKey key: String) -> Bool
    func exists(forKey key: String) -> Bool
}

// MARK: - UserDefaults Implementation

final class UserDefaultsStorage: LocalStorageService {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Single Object Operations

    func save<T: Codable>(_ object: T, forKey key: String) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
            print("✅ Saved object for key: \(key)")
            return true
        } catch {
            print("🔥 Error saving object for key \(key): \(error)")
            return false
        }
    }

    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            print("📭 No data found for key: \(key)")
            return nil
        }

        do {
            let object = try JSONDecoder().decode(type, from: data)
            print("✅ Loaded object for key: \(key)")
            return object
        } catch {
            print("🔥 Error decoding object for key \(key): \(error)")
            return nil
        }
    }

    // MARK: - Array Operations

    func saveArray<T: Codable>(_ array: [T], forKey key: String) -> Bool {
        do {
            let data = try JSONEncoder().encode(array)
            userDefaults.set(data, forKey: key)
            print("✅ Saved array (\(array.count) items) for key: \(key)")
            return true
        } catch {
            print("🔥 Error saving array for key \(key): \(error)")
            return false
        }
    }

    func loadArray<T: Codable>(_ type: T.Type, forKey key: String) -> [T] {
        guard let data = userDefaults.data(forKey: key) else {
            print("📭 No array data found for key: \(key)")
            return []
        }

        do {
            let array = try JSONDecoder().decode([T].self, from: data)
            print("✅ Loaded array (\(array.count) items) for key: \(key)")
            return array
        } catch {
            print("🔥 Error decoding array for key \(key): \(error)")
            return []
        }
    }

    // MARK: - Utility Operations

    func delete(forKey key: String) -> Bool {
        userDefaults.removeObject(forKey: key)
        print("🗑️ Deleted data for key: \(key)")
        return true
    }

    func exists(forKey key: String) -> Bool {
        return userDefaults.data(forKey: key) != nil
    }
}
