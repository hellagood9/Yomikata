import SwiftUI

struct MangaDetailHeader: View {
    let manga: Manga

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Imagen del manga
            MangaMainPicture(
                url: manga.cleanImageURL,
                assetName: manga.assetImageName
            )
            .frame(width: 120, height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 8)

            // Info básica
            VStack(alignment: .leading, spacing: 8) {
                Text(manga.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                // Authors
                Text(manga.authors.joinedFullNames(separator: " • "))
                    .font(.caption)
                    .foregroundColor(.secondary)

                // Rating si está disponible
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(manga.displayScore)
                        .fontWeight(.medium)
                }
                .font(.subheadline)

                // Estado de publicación
                StatusBadge(text: manga.statusDisplay, color: manga.statusColor)

                // Fechas de publicación
                if let startDateString = manga.startDate,
                    let startDate = parseDate(from: startDateString)
                {
                    HStack {
                        Text(
                            formatPublicationDates(
                                startDate: startDate,
                                endDateString: manga.endDate
                            )
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }
            Spacer()
        }
    }

    private func parseDate(from dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }

    private func formatPublicationDates(startDate: Date, endDateString: String?)
        -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        dateFormatter.locale = Locale.current  // Usa el idioma del dispositivo

        let startString = dateFormatter.string(from: startDate)

        if let endDateString = endDateString,
            let endDate = parseDate(from: endDateString)
        {
            let endString = dateFormatter.string(from: endDate)
            return "\(startString) - \(endString)"
        } else {
            return "\(startString) - " + "general.na".localized()
        }
    }
}

#Preview {
    MangaDetailHeader(manga: .preview)
}
