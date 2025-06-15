import Foundation

struct PaginatedResponse<T: Codable>: Codable {
    let items: T
    let metadata: PaginationMetadata
}

struct PaginationMetadata: Codable {
    let total: Int
    let page: Int
    let per: Int
}
