import Foundation
import SwiftUI

struct Manga: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let titleJapanese: String?
    let titleEnglish: String?
    let mainPicture: String?
    let synopsis: String?
    let background: String?
    let status: String?
    let score: Double?
    let volumes: Int?
    let chapters: Int?
    let startDate: String?
    let endDate: String?
    let url: String?
    let authors: [Author]
    let genres: [Genre]
    let themes: [Theme]
    let demographics: [Demographic]

    private enum CodingKeys: String, CodingKey {
        case id, title, titleJapanese, titleEnglish, mainPicture, background
        case synopsis = "sypnosis"  // Mapear el campo mal escrito
        case status, score, volumes, chapters, startDate, endDate, url
        case authors, genres, themes, demographics
    }

    private func cleanURL(_ urlString: String?) -> URL? {
        guard let urlString = urlString else { return nil }
        let cleaned = urlString.replacingOccurrences(of: "\"", with: "")
        return URL(string: cleaned)
    }

    var displayTitle: String {
        return title
    }

    var displayOriginalTitle: String {
        guard let titleJapanese = titleJapanese else { return "N/A" }
        return titleJapanese
    }

    var displayScore: String {
        guard let score = score else { return "N/A" }
        return String(format: "%.2f", score)
    }

    var cleanImageURL: URL? {
        return cleanURL(mainPicture)
    }

    var cleanWebsiteURL: URL? {
        return cleanURL(url)
    }

    var cleanSynopsis: String? {
        guard let synopsis = synopsis else { return nil }

        var cleanedText = synopsis

        // Remover texto entre corchetes (incluyendo "Written by MAL Rewrite" y similares)
        // No requiere que esté al final del string
        let bracketsPattern = #"\s*\[Written by.*?\]\s*"#
        cleanedText = cleanedText.replacingOccurrences(
            of: bracketsPattern,
            with: " ",  // Necesita este espacio
            options: .regularExpression
        )

        // Remover texto con patrón "(Source : xyz)" al final
        let sourcePattern = #"\s*\(Source\s*:\s*.*?\)\s*$"#
        cleanedText = cleanedText.replacingOccurrences(
            of: sourcePattern,
            with: " ",  // Necesita este espacio
            options: .regularExpression
        )

        let result = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        return result.isEmpty ? nil : result
    }

    var statusDisplay: String {
        guard let lowerStatus = status?.lowercased() else {
            return status ?? ""
        }

        switch lowerStatus {
        case MangaStatus.finished.rawValue:
            return "status.finished".localized()
        case MangaStatus.currentlyPublishing.rawValue:
            return "status.currently_publishing".localized()
        case MangaStatus.onHiatus.rawValue:
            return "status.on_hiatus".localized()
        default:
            return lowerStatus.capitalized
        }
    }

    var statusColor: Color {
        guard let lowerStatus = status?.lowercased() else { return .gray }

        switch lowerStatus {
        case MangaStatus.finished.rawValue:
            return .blue
        case MangaStatus.currentlyPublishing.rawValue:
            return .green
        case MangaStatus.onHiatus.rawValue:
            return .orange
        default:

            return .gray
        }
    }

    var volumeInfo: String {
        guard let volumes = volumes else {
            return "volumes.na".localized()
        }
        return String(
            format: "volumes.value".localized(),
            volumes
        )
    }

}

enum MangaStatus: String, CaseIterable {
    case finished = "finished"
    case currentlyPublishing = "currently_publishing"
    case onHiatus = "on_hiatus"
}

extension Manga {
    var assetImageName: String {
        cleanImageURL?
            .deletingPathExtension()
            .lastPathComponent ?? "placeholder"
    }
}
