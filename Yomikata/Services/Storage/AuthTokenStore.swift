import Foundation
import Security

/// Almacén seguro del TOKEN en Keychain
actor AuthTokenStore {
    static let shared = AuthTokenStore()

    private let service = Bundle.main.bundleIdentifier ?? "com.yomikata.app"
    private let account = "yomikata.auth.token"

    // MARK: - Public API

    @discardableResult
    func save(_ token: String) throws -> Bool {
        let data = Data(token.utf8)

        // Borrar si existe
        let queryDelete: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(queryDelete as CFDictionary)

        // Insertar nuevo
        let queryAdd: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String:
                kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
        ]
        let status = SecItemAdd(queryAdd as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        } else {
            throw NSError(domain: "Keychain", code: Int(status))
        }
    }

    func load() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    @discardableResult
    func clear() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    func exists() -> Bool { load() != nil }
}
