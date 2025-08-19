import Foundation

@MainActor
@Observable
final class RemoteMangaDetailViewModel {
    private(set) var isInCollection = false
    var errorMessage: String?

    private let api = APIService()

    // Estado inicial (consultamos api)
    func checkCollectionStatus(for manga: Manga) async {
        do {
            let item = try await api.fetchUserCollectionItem(mangaId: manga.id)
            isInCollection = (item != nil)
        } catch {
            isInCollection = false
            #if DEBUG
                print("❌ checkCollectionStatus error:", error)
            #endif
        }
    }

    func removeFromCollection(_ manga: Manga) async {
        do {
            try await api.deleteCollectionManga(mangaId: manga.id)
            isInCollection = false
            #if DEBUG
                print("✅ Removed \(manga.title) from remote collection")
            #endif
        } catch {
            #if DEBUG
                print("❌ removeFromCollection error:", error)
            #endif
        }
    }

    func addToCollection(
        manga: Manga,
        volumesOwned: [Int],
        currentVolume: Int?,
        isCompleteCollection: Bool
    ) async {
        do {
            try await api.addOrUpdateCollectionManga(
                mangaId: manga.id,
                volumesOwned: volumesOwned,
                readingVolume: currentVolume,
                completeCollection: isCompleteCollection
            )
            isInCollection = true
            #if DEBUG
                print("✅ Added \(manga.title) to remote collection")
            #endif
        } catch {
            #if DEBUG
                print("❌ addToCollection error:", error)
            #endif
        }
    }
}
