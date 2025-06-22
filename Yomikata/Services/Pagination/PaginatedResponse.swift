import Foundation

struct PaginatedResponse<T: Codable & Sendable>: Codable, Sendable {
    let items: T
    let metadata: PaginationMetadata
}

struct PaginationMetadata: Codable, Sendable {
    let total: Int
    let page: Int
    let per: Int
}
