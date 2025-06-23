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
                Text(manga.authors.joinedStringValues(separator: " • ", keyPath: \.fullName))
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

                Spacer()
            }
            Spacer()
        }
    }

}

#Preview {
    MangaDetailHeader(manga: .preview)
}
