import Foundation

private struct RemoteCollectionItem: Codable {
    let id: String
    let completeCollection: Bool
    let volumesOwned: [Int]
    let readingVolume: Int?
    let manga: Manga
}

extension APIService {

    // GET /collection/manga  (Bearer + App-Token)
    func fetchUserCollection() async throws -> [MangaCollection] {
        let endpoint = APIEndpoint.Collection.all
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        var req = try await bearerRequest(url: url, method: .get)
        req = req.adding(headers: [
            APIConstants.appTokenHeader: APIConstants.appToken
        ])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }

        #if DEBUG
            print("⬅️ GET \(endpoint) status:", http.statusCode)
        #endif

        if http.statusCode == 401 {
            await AuthTokenStore.shared.clear()
            throw NetworkError.unauthorized
        }
        guard (200...299).contains(http.statusCode) else {
            throw NetworkError.serverError(http.statusCode)
        }

        let remote = try JSONDecoder().decode(
            [RemoteCollectionItem].self, from: data)

        return remote.map {
            MangaCollection(
                manga: $0.manga,
                volumesOwned: $0.volumesOwned,
                readingVolume: $0.readingVolume,
                completeCollection: $0.completeCollection
            )
        }
    }

    // GET /collection/manga/{id}  → existe/no existe
    func fetchUserCollectionItem(mangaId: Int) async throws -> MangaCollection?
    {
        let endpoint = APIEndpoint.Collection.manga(mangaId)
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        var req = try await bearerRequest(url: url, method: .get)
        req = req.adding(headers: [
            APIConstants.appTokenHeader: APIConstants.appToken
        ])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }

        #if DEBUG
            print("⬅️ GET \(endpoint) status:", http.statusCode)
        #endif

        switch http.statusCode {
        case 200:
            let r = try JSONDecoder().decode(
                RemoteCollectionItem.self, from: data)
            return MangaCollection(
                manga: r.manga,
                volumesOwned: r.volumesOwned,
                readingVolume: r.readingVolume,
                completeCollection: r.completeCollection
            )
        case 401:
            await AuthTokenStore.shared.clear()
            throw NetworkError.unauthorized
        case 404:
            return nil
        default:
            throw NetworkError.serverError(http.statusCode)
        }
    }

    // POST /collection/manga (upsert)
    func addOrUpdateCollectionManga(
        mangaId: Int,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async throws {
        struct Body: Codable {
            let manga: Int
            let completeCollection: Bool
            let volumesOwned: [Int]
            let readingVolume: Int?
        }

        let endpoint = APIEndpoint.Collection.all
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        let body = Body(
            manga: mangaId,
            completeCollection: completeCollection,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume
        )

        var req = try await bearerJSONRequest(
            url: url, method: .post, json: body)
        req = req.adding(headers: [
            APIConstants.appTokenHeader: APIConstants.appToken
        ])

        let (_, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }

        #if DEBUG
            print("⬅️ POST \(endpoint) status:", http.statusCode)
        #endif

        switch http.statusCode {
        case 200...299: return
        case 401:
            await AuthTokenStore.shared.clear()
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(http.statusCode)
        }
    }

    // DELETE /collection/manga/{id}
    func deleteCollectionManga(mangaId: Int) async throws {
        let endpoint = APIEndpoint.Collection.manga(mangaId)
        guard let url = URL(string: "\(APIConstants.baseURL)\(endpoint)") else {
            throw NetworkError.invalidURL
        }

        var req = try await bearerRequest(url: url, method: .delete)
        req = req.adding(headers: [
            APIConstants.appTokenHeader: APIConstants.appToken
        ])

        let (_, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else {
            throw NetworkError.connectionFailed
        }

        #if DEBUG
            print("⬅️ DELETE \(endpoint) status:", http.statusCode)
        #endif

        switch http.statusCode {
        case 200...299: return
        case 401:
            await AuthTokenStore.shared.clear()
            throw NetworkError.unauthorized
        case 404:
            return
        default:
            throw NetworkError.serverError(http.statusCode)
        }
    }
}
