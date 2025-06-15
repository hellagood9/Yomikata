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

    /// Añade un manga a la colección
    func addToCollection(
        _ manga: Manga, volumesPurchased: Int = 0, currentVolume: Int = 1,
        isCompleteCollection: Bool = false
    ) -> Bool {
        // Verificar si ya existe
        if isInCollection(manga) {
            print("⚠️ Manga \(manga.title) already in collection")
            return false
        }

        var collection = getCollection()
        let collectionManga = MangaCollection(
            manga: manga,
            volumesPurchased: volumesPurchased,
            currentVolume: currentVolume,
            isCompleteCollection: isCompleteCollection
        )

        collection.append(collectionManga)
        return storage.saveArray(collection, forKey: collectionKey)
    }

    /// Actualiza un manga en la colección
    func updateInCollection(
        _ manga: Manga, volumesPurchased: Int, currentVolume: Int,
        isCompleteCollection: Bool
    ) -> Bool {
        var collection = getCollection()

        guard
            let index = collection.firstIndex(where: { $0.manga.id == manga.id }
            )
        else {
            print("⚠️ Manga \(manga.title) not found in collection")
            return false
        }

        collection[index].volumesPurchased = volumesPurchased
        collection[index].currentVolume = currentVolume
        collection[index].isCompleteCollection = isCompleteCollection

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
        let completedCollections = collection.filter { $0.isCompleteCollection }
            .count
        let totalVolumesOwned = collection.reduce(0) {
            $0 + $1.volumesPurchased
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
