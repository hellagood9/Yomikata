enum APIEndpoint {

    // MARK: - Users  // PATCH ▼
    enum Users {
        static let register = "/users"  // POST (App-Token)
        static let login = "/users/login"  // POST (Basic)
        static let renew = "/users/renew"  // POST (Bearer)
    }

    // MARK: - List
    enum List {
        static let mangas = "/list/mangas"
        static let bestMangas = "/list/bestMangas"
        static let authors = "/list/authors"
        static let demographics = "/list/demographics"
        static let genres = "/list/genres"
        static let themes = "/list/themes"

        static func mangaByGenre(_ genre: String) -> String {
            "/list/mangaByGenre/\(genre)"
        }

        static func mangaByDemographic(_ demo: String) -> String {
            "/list/mangaByDemographic/\(demo)"
        }

        static func mangaByTheme(_ theme: String) -> String {
            "/list/mangaByTheme/\(theme)"
        }

        static func mangaByAuthor(_ authorID: String) -> String {
            "/list/mangaByAuthor/\(authorID)"
        }
    }

    // MARK: - Search
    enum Search {
        static func mangasBeginsWith(_ text: String) -> String {
            "/search/mangasBeginsWith/\(text)"
        }

        static func mangasContains(_ text: String) -> String {
            "/search/mangasContains/\(text)"
        }

        static func author(_ name: String) -> String {
            "/search/author/\(name)"
        }

        static func manga(_ id: Int) -> String {
            "/search/manga/\(id)"
        }

        static let custom = "/search/manga"  // POST
    }

    // MARK: - Collection
    enum Collection {
        static let all = "/collection/manga"  // GET & POST

        static func manga(_ id: Int) -> String {
            "/collection/manga/\(id)"
        }
    }
}
