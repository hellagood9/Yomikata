import Foundation

@MainActor
@Observable
final class CollectionViewModel {

    // MARK: - Published State
    var collectionMangas: [MangaCollection] = []
    var isLoading = false
    var errorMessage: String?

    var stats: CollectionStats {
        CollectionStats(
            totalMangas: collectionMangas.count,
            completedCollections: collectionMangas.filter {
                $0.completeCollection
            }.count,
            totalVolumesOwned: collectionMangas.reduce(0) {
                $0 + $1.volumesOwned.count
            }
        )
    }

    private let collectionService: CollectionService

    // MARK: - Initialization

    init(collectionService: CollectionService = CollectionService()) {
        self.collectionService = collectionService
    }

    // MARK: - Public Interface

    /// Carga la colección del usuario
    func loadCollection() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        collectionMangas = collectionService.getCollection()
        print("✅ Loaded collection: \(collectionMangas.count) mangas")
    }

    /// Elimina un manga de la colección
    func removeFromCollection(_ collectionManga: MangaCollection) async {
        let success = collectionService.removeFromCollection(
            collectionManga.manga)
        if success {
            collectionMangas.removeAll {
                $0.manga.id == collectionManga.manga.id
            }
            print("✅ Removed \(collectionManga.manga.title) from collection")
        } else {
            errorMessage = "collection.error.remove".localized()
        }
    }

    /// Verifica si un manga está en la colección
    func isInCollection(_ manga: Manga) -> Bool {
        return collectionService.isInCollection(manga)
    }

    func addToCollection(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async {
        let item = MangaCollection(
            manga: manga,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )

        let success = collectionService.addToCollection(item)
        if success {
            await loadCollection()
            print("✅ Added \(manga.title) to collection")
        } else {
            errorMessage = "collection.error.add".localized()
        }
    }

    func updateCollection(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async {
        let updated = MangaCollection(
            manga: manga,
            volumesOwned: volumesOwned,
            readingVolume: readingVolume,
            completeCollection: completeCollection
        )

        let success = collectionService.updateInCollection(updated)
        if success {
            await loadCollection()
            print("✏️ Updated \(manga.title) in collection")
        } else {
            errorMessage = "collection.error.update".localized()
        }
    }

    // MARK: - Computed Properties

    var isEmpty: Bool {
        collectionMangas.isEmpty
    }
}
