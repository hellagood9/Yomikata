import Foundation

extension Manga {
    static let previews: [Manga] = {
        typealias MangaResponse = PaginatedResponse<[Manga]>
                                                            
        guard
            let response: MangaResponse = Bundle.main.decode(
                MangaResponse.self, from: "mangas-sample.json")
        else {
            print("❌ Failed to load Manga.previews")
            return []
        }
        return response.items
    }()
}
