import Foundation

/// Servicio remoto que delega en APIService+Collection
struct RemoteCollectionService: Sendable {

    // MARK: - Dependencies
    private let api = APIService()

    // MARK: - Read

    func getCollection() async throws -> [MangaCollection] {
        try await api.fetchUserCollection()
    }

    func getCollectionManga(for manga: Manga) async throws -> MangaCollection? {
        try await api.fetchUserCollectionItem(mangaId: manga.id)
    }

    func isInCollection(_ manga: Manga) async throws -> Bool {
        try await getCollectionManga(for: manga) != nil
    }

    // MARK: - Write (upsert / delete)

    @discardableResult
    func addToCollection(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async throws -> MangaCollection {
        try await api.addOrUpdateCollectionManga(
            mangaId: manga.id,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )
        return MangaCollection(
            manga: manga,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )
    }

    @discardableResult
    func updateCollection(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async throws -> MangaCollection {
        try await api.addOrUpdateCollectionManga(
            mangaId: manga.id,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )
        return MangaCollection(
            manga: manga,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )
    }

    func removeFromCollection(manga item: MangaCollection) async throws {
        try await api.deleteCollectionManga(mangaId: item.manga.id)
    }

    /// Debug helper (borra en serie)
    func clearCollection() async throws {
        let items = try await getCollection()
        try await withThrowingTaskGroup(of: Void.self) { group in
            for it in items {
                group.addTask {
                    try await api.deleteCollectionManga(mangaId: it.manga.id)
                }
            }
            try await group.waitForAll()
        }
    }

}
