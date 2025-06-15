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
    
    /// Alterna el estado de colección de un manga
    func toggleCollection(for manga: Manga) async {
        if isInCollection {
            let success = collectionService.removeFromCollection(manga)
            if success {
                isInCollection = false
                print("✅ Removed \(manga.title) from collection")
            }
        } else {
            let success = collectionService.addToCollection(manga)
            if success {
                isInCollection = true
                print("✅ Added \(manga.title) to collection")
            }
        }
    }
}
