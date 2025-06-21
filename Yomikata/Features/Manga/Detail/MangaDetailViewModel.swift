import Foundation

@Observable
class MangaDetailViewModel {
    private(set) var isInCollection = false

    // MARK: - Dependencies
    private let collectionService: CollectionService

    // MARK: - Initialization
    init(collectionService: CollectionService = CollectionService()) {
        self.collectionService = collectionService
    }

    // MARK: - Public Interface
    
    /// Verifica el estado inicial de un manga en la colección
    func checkCollectionStatus(for manga: Manga) {
        isInCollection = collectionService.isInCollection(manga)
    }

    func removeFromCollection(_ manga: Manga) async {
        let success = collectionService.removeFromCollection(manga)
        if success {
            isInCollection = false
            print("✅ Removed \(manga.title) from collection")
        }
    }

    func addToCollection(
        manga: Manga,
        volumesPurchased: Int,
        currentVolume: Int?,
        isCompleteCollection: Bool
    ) async {
        let item = MangaCollection(
            manga: manga,
            volumesOwned: Array(1...volumesPurchased),
            readingVolume: currentVolume,
            completeCollection: isCompleteCollection
        )

        let success = collectionService.addToCollection(item)
        if success {
            isInCollection = true
            print("✅ Added \(manga.title) to collection")
        }
    }
}
