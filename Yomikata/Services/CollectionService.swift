import Foundation

final class CollectionService {

    // MARK: - Dependencies

    private let storage: LocalStorageService
    private let collectionKey = "user_manga_collection"

    // MARK: - Initialization

    init(storage: LocalStorageService = UserDefaultsStorage()) {
        self.storage = storage
    }

    // MARK: - Public Interface

    /// Obtiene toda la colección del usuario
    func getCollection() -> [MangaCollection] {
        let collection = storage.loadArray(
            MangaCollection.self, forKey: collectionKey)
        return collection.sorted { $0.dateAdded > $1.dateAdded }  // Más recientes primero
    }

    /// Verifica si un manga está en la colección
    func isInCollection(_ manga: Manga) -> Bool {
        let collection = getCollection()
        return collection.contains { $0.manga.id == manga.id }
    }

    /// Añade el manga a  la colección
    func addToCollection(_ item: MangaCollection) -> Bool {
        if isInCollection(item.manga) {
            print("⚠️ Manga \(item.manga.title) already in collection")
            return false
        }

        var collection = getCollection()
        collection.append(item)
        return storage.saveArray(collection, forKey: collectionKey)
    }

    /// Actualiza un manga en la colección
    func updateInCollection(_ item: MangaCollection) -> Bool {
        var collection = getCollection()

        guard
            let index = collection.firstIndex(where: {
                $0.manga.id == item.manga.id
            })
        else {
            print(
                "⚠️ Manga \(item.manga.title) not found in collection for update"
            )
            return false
        }

        collection[index] = item
        return storage.saveArray(collection, forKey: collectionKey)
    }

    /// Elimina un manga de la colección
    func removeFromCollection(_ manga: Manga) -> Bool {
        var collection = getCollection()

        guard
            let index = collection.firstIndex(where: { $0.manga.id == manga.id }
            )
        else {
            print("⚠️ Manga \(manga.title) not found in collection")
            return false
        }

        collection.remove(at: index)
        return storage.saveArray(collection, forKey: collectionKey)
    }

    /// Obtiene un manga específico de la colección
    func getCollectionManga(for manga: Manga) -> MangaCollection? {
        let collection = getCollection()
        return collection.first { $0.manga.id == manga.id }
    }

    /// Obtiene estadísticas de la colección
    func getCollectionStats() -> CollectionStats {
        let collection = getCollection()

        let totalMangas = collection.count
        let completedCollections = collection.filter { $0.completeCollection }
            .count
        let totalVolumesOwned = collection.reduce(0) {
            $0 + $1.volumesOwned.count
        }

        return CollectionStats(
            totalMangas: totalMangas,
            completedCollections: completedCollections,
            totalVolumesOwned: totalVolumesOwned
        )
    }

    /// Limpia toda la colección (para testing/debug)
    func clearCollection() -> Bool {
        return storage.delete(forKey: collectionKey)
    }
}
