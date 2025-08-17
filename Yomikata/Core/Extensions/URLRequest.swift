import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

extension URLRequest {
    static func get(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    static func post<JSON>(url: URL, json: JSON) throws -> URLRequest
    where JSON: Encodable {
        var request = URLRequest(url: url)
        request.timeoutInterval = 25
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(json)
        return request
    }
}

extension URLRequest {
    static func post(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 25
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    func adding(headers: [String: String]) -> URLRequest {
        var r = self
        headers.forEach { r.setValue($0.value, forHTTPHeaderField: $0.key) }
        return r
    }
}
