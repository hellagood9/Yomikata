import Foundation

#if DEBUG
    import os
    private let apiLog = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Yomikata",
        category: "API")
#endif

final class APIService: Sendable {

    // MARK: - Manga Operations

    func getMangas(page: Int = 1, per: Int = APIConstants.defaultItemsPerPage)
        async throws -> PaginatedResponse<[Manga]>
    {
        let endpoint = "\(APIEndpoint.List.mangas)?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    func getManga(id: Int) async throws -> Manga {
        guard
            let url = URL(
                string: "\(APIConstants.baseURL)\(APIEndpoint.Search.manga(id))"
            )
        else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: Manga.self)
    }

    // MARK: - Search Operations

    func searchMangasBeginsWith(_ text: String) async throws
        -> PaginatedResponse<[Manga]>
    {
        let endpoint = APIEndpoint.Search.mangasBeginsWith(text)
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    func searchMangasContains(
        _ text: String,
        page: Int = 1,
        per: Int = APIConstants.defaultItemsPerPage
    ) async throws -> PaginatedResponse<[Manga]> {
        let endpoint =
            "\(APIEndpoint.Search.mangasContains(text))?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    func searchAuthors(_ text: String) async throws -> [Author] {
        let endpoint = "\(APIEndpoint.Search.author(text))"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: [Author].self)
    }

    /// Búsqueda avanzada con múltiples filtros simultáneos
    func customSearchMangas(
        _ customSearch: CustomSearch,
        page: Int = 1,
        per: Int = APIConstants.defaultItemsPerPage
    ) async throws -> PaginatedResponse<[Manga]> {

        let endpoint = "\(APIEndpoint.Search.custom)?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = try URLRequest.post(url: url, json: customSearch)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    // MARK: - Filter Operations

    func getGenres() async throws -> [String] {
        let endpoint = APIEndpoint.List.genres
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: [String].self)
    }

    func getMangasByAuthor(
        _ authorId: String, page: Int = 1,
        per: Int = APIConstants.defaultItemsPerPage
    ) async throws -> PaginatedResponse<[Manga]> {
        let endpoint =
            "\(APIEndpoint.List.mangaByAuthor(authorId))?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }
        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    func getMangasByGenre(
        _ genre: String, page: Int = 1,
        per: Int = APIConstants.defaultItemsPerPage
    ) async throws -> PaginatedResponse<[Manga]> {
        let endpoint =
            "\(APIEndpoint.List.mangaByGenre(genre))?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    func getMangasByTheme(
        _ theme: String, page: Int = 1,
        per: Int = APIConstants.defaultItemsPerPage
    ) async throws -> PaginatedResponse<[Manga]> {
        let endpoint =
            "\(APIEndpoint.List.mangaByTheme(theme))?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

    func getMangasByDemographic(
        _ demographic: String, page: Int = 1,
        per: Int = APIConstants.defaultItemsPerPage
    ) async throws -> PaginatedResponse<[Manga]> {
        let endpoint =
            "\(APIEndpoint.List.mangaByDemographic(demographic))?page=\(page)&per=\(per)"
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: PaginatedResponse<[Manga]>.self)
    }

}

extension APIService {

    // MARK: - Extended Filter Data Loading

    func getThemes() async throws -> [String] {
        let endpoint = APIEndpoint.List.themes
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: [String].self)
    }

    func getDemographics() async throws -> [String] {
        let endpoint = APIEndpoint.List.demographics
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: [String].self)
    }

    func getAuthors() async throws -> [Author] {
        let endpoint = APIEndpoint.List.authors
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let request = URLRequest.get(url: url)
        return try await URLSession.shared.getJSON(
            from: request, type: [Author].self)
    }
}

private struct ServerErrorBody: Decodable {
    let error: Bool?
    let reason: String?
}

// MARK: - Users (register / login / renew)
extension APIService {

    func registerUser(email: String, password: String) async throws {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard let url = URL(string: "\(APIConstants.baseURL)/users") else {
            throw NetworkError.invalidURL
        }

        var req = try URLRequest.post(
            url: url, json: Users(email: email, password: password))
        req = req.adding(headers: [
            APIConstants.appTokenHeader: APIConstants.appToken
        ])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }

        #if DEBUG
            let body = String(data: data, encoding: .utf8) ?? ""
            apiLog.info(
                "⬅️ /users status: \(http.statusCode) | body: \(body, privacy: .public)"
            )
        #endif

        guard (200...299).contains(http.statusCode) else {
            let reason =
                (try? JSONDecoder().decode(ServerErrorBody.self, from: data))?
                .reason
            switch http.statusCode {
            case 401: throw NetworkError.unauthorized
            case 403: throw NetworkError.forbidden
            case 404: throw NetworkError.notFound
            default:
                throw NetworkError.serverError(http.statusCode, reason: reason)
            }
        }
    }

    // Login (Basic) -> token como String plano
    func loginUser(email: String, password: String) async throws -> String {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        guard let url = URL(string: "\(APIConstants.baseURL)/users/login")
        else {
            throw NetworkError.invalidURL
        }

        var req = URLRequest.post(url: url)  // sin body
        let basic = Data("\(email):\(password)".utf8).base64EncodedString()
        req = req.adding(headers: ["Authorization": "Basic \(basic)"])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }

        #if DEBUG
            let raw = String(data: data, encoding: .utf8) ?? ""
            apiLog.info(
                "⬅️ /users/login(Basic) status: \(http.statusCode) | body: \(raw, privacy: .public)"
            )
        #endif

        guard (200...299).contains(http.statusCode) else {
            let reason =
                (try? JSONDecoder().decode(ServerErrorBody.self, from: data))?
                .reason
            switch http.statusCode {
            case 401: throw NetworkError.unauthorized
            case 403: throw NetworkError.forbidden
            case 404: throw NetworkError.notFound
            default:
                throw NetworkError.serverError(http.statusCode, reason: reason)
            }
        }

        guard
            let token = String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines),
            !token.isEmpty
        else {
            throw NetworkError.decodingFailed(URLError(.cannotDecodeRawData))
        }
        return token
    }

    // Renew (Bearer + App-Token). Acepta JSON {token: "..."} o string plano
    // Devuelve true si guardó token nuevo. Si falla, NO limpia; ya se validará luego
    @discardableResult
    func renewTokenIfNeeded() async -> Bool {
        guard let current = await AuthTokenStore.shared.load() else {
            return false
        }
        guard
            let url = URL(
                string: "\(APIConstants.baseURL)\(APIEndpoint.Users.renew)")
        else { return false }

        var req = URLRequest.post(url: url)
        req = req.adding(headers: [
            "Authorization": "Bearer \(current)",
            APIConstants.appTokenHeader: APIConstants.appToken,
        ])

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else { return false }

            #if DEBUG
                print(
                    "⬅️ /users/renew status:", http.statusCode, "| body:",
                    String(data: data, encoding: .utf8) ?? "")
            #endif

            if http.statusCode == 401 {
                await AuthTokenStore.shared.clear()  // LIMPIAR Token si 401
                return false
            }
            guard (200...299).contains(http.statusCode) else { return false }

            // acepta JSON {token:"..."} o string plano
            if let json = try? JSONDecoder().decode(
                TokenResponse.self, from: data),
                !json.token.isEmpty
            {
                try await AuthTokenStore.shared.save(json.token)
                return true
            }
            if let token = String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines),
                !token.isEmpty
            {
                try await AuthTokenStore.shared.save(token)
                return true
            }
            return false
        } catch {
            #if DEBUG
                print("🔁 Renew FAILED:", error)
            #endif
            return false
        }
    }

    // Logout
    @discardableResult
    func logout() async -> Bool { await AuthTokenStore.shared.clear() }
}

// MARK: - Bearer helpers
extension APIService {
    func bearerRequest(url: URL, method: HTTPMethod = .get)
        async throws -> URLRequest
    {
        guard let token = await AuthTokenStore.shared.load() else {
            throw NetworkError.unauthorized
        }
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return req
    }

    func bearerJSONRequest<Body: Encodable>(
        url: URL, method: HTTPMethod = .post, json body: Body
    ) async throws -> URLRequest {
        var req = try await bearerRequest(url: url, method: method)
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONEncoder().encode(body)
        return req
    }
}
