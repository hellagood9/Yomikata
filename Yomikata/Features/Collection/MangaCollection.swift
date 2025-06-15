import Foundation

struct MangaCollection: Codable, Identifiable {
    let id = UUID()
    let manga: Manga
    var volumesPurchased: Int  // Número de tomos comprados
    var currentVolume: Int  // Tomo por el que va leyendo
    var isCompleteCollection: Bool  // Si tiene colección completa
    let dateAdded: Date

    private enum CodingKeys: String, CodingKey {
        case manga, volumesPurchased, currentVolume, isCompleteCollection,
            dateAdded
        // id se excluye porque es generado automáticamente
    }

    // MARK: - Initialization

    init(
        manga: Manga, volumesPurchased: Int = 0, currentVolume: Int = 1,
        isCompleteCollection: Bool = false
    ) {
        self.manga = manga
        self.volumesPurchased = volumesPurchased
        self.currentVolume = currentVolume
        self.isCompleteCollection = isCompleteCollection
        self.dateAdded = Date()
    }

    // MARK: - Computed Properties

    /// Progreso de lectura como porcentaje (0.0 - 1.0)
    var readingProgress: Double {
        guard let totalVolumes = manga.volumes, totalVolumes > 0 else {
            return 0.0
        }
        return Double(currentVolume) / Double(totalVolumes)
    }

    /// Progreso de compra como porcentaje (0.0 - 1.0)
    var purchaseProgress: Double {
        guard let totalVolumes = manga.volumes, totalVolumes > 0 else {
            return 0.0
        }
        return Double(volumesPurchased) / Double(totalVolumes)
    }

    /// Información de progreso para mostrar en UI
    var progressInfo: String {
        guard let totalVolumes = manga.volumes else {
            return "collection.progress.unknown".localized()
        }

        if isCompleteCollection {
            return "collection.progress.complete".localized()
        }

        return String(
            format: "collection.progress.format".localized(), currentVolume,
            totalVolumes)
    }

    /// Información de volúmenes comprados
    var purchaseInfo: String {
        guard let totalVolumes = manga.volumes else {
            return "collection.purchase.unknown".localized()
        }

        return String(
            format: "collection.purchase.format".localized(), volumesPurchased,
            totalVolumes)
    }
}

struct CollectionStats {
    let totalMangas: Int
    let completedCollections: Int
    let totalVolumesOwned: Int

    var completionRate: Double {
        guard totalMangas > 0 else { return 0.0 }
        return Double(completedCollections) / Double(totalMangas)
    }
}
