import Foundation

struct Users: Codable {
    let email: String
    let password: String
}

struct TokenResponse: Codable {
    let token: String
}
