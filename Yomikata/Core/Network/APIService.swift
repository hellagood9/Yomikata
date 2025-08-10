import Foundation

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
