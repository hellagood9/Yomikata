import Foundation

struct CustomSearch: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool

    init(
        searchTitle: String? = nil,
        searchAuthorFirstName: String? = nil,
        searchAuthorLastName: String? = nil,
        searchGenres: [String]? = nil,
        searchThemes: [String]? = nil,
        searchDemographics: [String]? = nil,
        searchContains: Bool = true
    ) {
        self.searchTitle = searchTitle
        self.searchAuthorFirstName = searchAuthorFirstName
        self.searchAuthorLastName = searchAuthorLastName
        self.searchGenres = searchGenres
        self.searchThemes = searchThemes
        self.searchDemographics = searchDemographics
        self.searchContains = searchContains
    }
}
