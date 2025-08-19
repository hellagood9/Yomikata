import Foundation

@MainActor
@Observable
final class RemoteCollectionViewModel {

    // MARK: - Published State
    var collectionMangas: [MangaCollection] = []
    var isLoading = false
    var errorMessage: String?

    // Cache en memoria de IDs para consultas O(1)
    private var inMemoryIds = Set<Int>()

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

    private let collectionService: RemoteCollectionService

    // MARK: - Initialization
    init(collectionService: RemoteCollectionService = RemoteCollectionService())
    {
        self.collectionService = collectionService
    }

    // MARK: - Public Interface

    /// Carga la colección del usuario desde la API
    func loadCollection() async {
        if isLoading { return }  // evita dobles cargas (task + refresh)
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let list = try await collectionService.getCollection()
            collectionMangas = list
            inMemoryIds = Set(list.map { $0.manga.id })  // refresca cache
            print("✅ Loaded remote collection: \(list.count) mangas")
        } catch {
            errorMessage = "collection.error.load".localized()
            print("❌ Failed to load remote collection: \(error)")
        }
    }

    /// Vacía la colección en remoto
    func clearCollection() async {
        do {
            try await collectionService.clearCollection()
            collectionMangas.removeAll()
            inMemoryIds.removeAll()  // sync cache
            print("✅ Remote collection cleared successfully")
        } catch {
            errorMessage = "collection.error.clear".localized()
            print("❌ Failed to clear remote collection: \(error)")
        }
    }

    /// Elimina un manga de la colección remota
    func removeFromCollection(_ collectionManga: MangaCollection) async {
        do {
            try await collectionService.removeFromCollection(
                manga: collectionManga)
            collectionMangas.removeAll {
                $0.manga.id == collectionManga.manga.id
            }
            inMemoryIds.remove(collectionManga.manga.id)  // sync cache
            print(
                "✅ Removed \(collectionManga.manga.title) from remote collection"
            )
        } catch {
            errorMessage = "collection.error.remove".localized()
            print("❌ Failed to remove from remote collection: \(error)")
        }
    }

    /// Verifica si un manga está en la colección remota
    func isInCollection(_ manga: Manga) async -> Bool {
        if inMemoryIds.contains(manga.id) { return true }  // evita red si ya cargado

        do {
            return try await collectionService.isInCollection(manga)
        } catch {
            print("❌ Failed to check collection: \(error)")
            return false
        }
    }

    /// Añade un manga a la colección remota
    func addToCollection(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async {
        do {
            let item = try await collectionService.addToCollection(
                manga: manga,
                volumesOwned: volumesOwned,
                readingVolume: readingVolume,
                completeCollection: completeCollection
            )
            collectionMangas.append(item)
            inMemoryIds.insert(manga.id)  // sync cache
            print("✅ Added \(manga.title) to remote collection")
        } catch {
            errorMessage = "collection.error.add".localized()
            print("❌ Failed to add to remote collection: \(error)")
        }
    }

    /// Actualiza un manga en la colección remota
    func updateCollection(
        manga: Manga,
        volumesOwned: [Int],
        readingVolume: Int?,
        completeCollection: Bool
    ) async {
        do {
            let updated = try await collectionService.updateCollection(
                manga: manga,
                volumesOwned: volumesOwned,
                readingVolume: readingVolume,
                completeCollection: completeCollection
            )
            if let index = collectionMangas.firstIndex(where: {
                $0.manga.id == updated.manga.id
            }) {
                collectionMangas[index] = updated
            } else {
                collectionMangas.append(updated)
            }
            inMemoryIds.insert(manga.id)  // aseguro consistencia
            print("✏️ Updated \(manga.title) in remote collection")
        } catch {
            errorMessage = "collection.error.update".localized()
            print("❌ Failed to update remote collection: \(error)")
        }
    }

    // MARK: - Computed Properties
    var isEmpty: Bool { collectionMangas.isEmpty }
}
