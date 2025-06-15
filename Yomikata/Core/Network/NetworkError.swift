import Foundation

enum NetworkError: LocalizedError, Sendable {
    case invalidURL
    case connectionFailed
    case unauthorized
    case forbidden
    case notFound
    case serverError(Int)
    case decodingFailed(Error)
    case requestFailed(Error)
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "network_error_invalid_url".localized(
                fallback: "Invalid URL")
        case .connectionFailed:
            return "network_error_connection_failed".localized(
                fallback: "Could not connect to the server")
        case .unauthorized:
            return "network_error_unauthorized".localized(
                fallback: "Unauthorized access")
        case .forbidden:
            return "network_error_forbidden".localized(
                fallback: "Access denied")
        case .notFound:
            return "network_error_not_found".localized(
                fallback: "Resource not found")
        case .serverError(let code):
            return "network_error_server_\(code)".localized(
                fallback: "Server error: \(code)")
        case .decodingFailed(let error):
            return "network_error_decoding".localized(
                fallback:
                    "Failed to decode response: \(error.localizedDescription)")
        case .requestFailed(let error):
            return "network_error_request_failed".localized(
                fallback: "Request failed: \(error.localizedDescription)")
        case .noData:
            return "network_error_no_data".localized(
                fallback: "No data received")
        }
    }
}
