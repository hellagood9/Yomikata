import Foundation

extension String {
    func localized(fallback: String? = nil) -> String {
        let value = NSLocalizedString(self, comment: "")
        return value == self ? (fallback ?? self) : value
    }
}

extension String {
    var localizedTheme: String {
        let themeKey = "theme.\(self.lowercased().replacingOccurrences(of: " ", with: "_"))"
        let localized = themeKey.localized()
        
        // Si no encuentra la traducción, devuelve capitalizado
        return localized == themeKey ? self.capitalized : localized
    }
    
    var localizedDemographic: String {
        switch self.lowercased() {
        case "shounen":
            return "shounen".localized()
        case "shoujo":
            return "shoujo".localized()
        case "seinen":
            return "seinen".localized()
        case "josei":
            return "josei".localized()
        case "kids", "kodomomuke":
            return "kids".localized()
        default:
            return self.capitalized
        }
    }
    
    var localizedGenre: String {
        let genreKey = "genre.\(self.lowercased().replacingOccurrences(of: " ", with: "_"))"
        let localized = genreKey.localized()
        
        // Si no encuentra la traducción, devuelve capitalizado
        return localized == genreKey ? self.capitalized : localized
    }
}

extension String {
    var isValidEmail: Bool {
        let email = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let regex =
        "^[A-Z0-9._%+-]+@[A-Z0-9-]+\\.[A-Z]{2,63}(?:\\.[A-Z]{2,63})*$"
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: email)
    }
}
