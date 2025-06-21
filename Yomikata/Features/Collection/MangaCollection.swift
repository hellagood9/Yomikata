import Foundation

struct MangaCollection: Codable, Identifiable {
    let id = UUID()
    let manga: Manga
    var volumesOwned: [Int]              // Ej: [1, 2, 3, 5]
    var readingVolume: Int?              // Tomo actual de lectura (opcional)
    var completeCollection: Bool         // Si la colección está completa
    let dateAdded: Date
    
    private enum CodingKeys: String, CodingKey {
        // id se excluye porque es generado automáticamente
        case manga, volumesOwned, readingVolume, completeCollection, dateAdded
    }

    // MARK: - Initialization

    init(
        manga: Manga,
        volumesOwned: [Int] = [],
        readingVolume: Int? = nil,
        completeCollection: Bool = false
    ) {
        self.manga = manga
        self.volumesOwned = volumesOwned
        self.readingVolume = readingVolume
        self.completeCollection = completeCollection
        self.dateAdded = Date()
    }
    
    // MARK: - Computed Properties
    
    var totalVolumes: Int? {
        return manga.volumes
    }
    
    /// Progreso de lectura como porcentaje (0.0 - 1.0)
    var readingProgress: Double {
        guard let total = manga.volumes, let current = readingVolume, total > 0 else {
            return 0.0
        }
        return Double(current) / Double(total)
    }
    
    var purchaseProgress: Double {
        guard let total = manga.volumes, total > 0 else {
            return 0.0
        }
        return Double(volumesOwned.count) / Double(total)
    }
    
    var progressInfo: String {
        guard let total = manga.volumes, let current = readingVolume else {
            return "collection.progress.unknown".localized()
        }
        
        if completeCollection {
            return "collection.progress.complete".localized()
        }
        
        return String(format: "collection.progress.format".localized(), current, total)
    }

    /// Información de volúmenes comprados
    var purchaseInfo: String {
        guard let total = manga.volumes else {
            return "collection.purchase.unknown".localized()
        }
        
        return String(format: "collection.purchase.format".localized(), volumesOwned.count, total)
    }
}
