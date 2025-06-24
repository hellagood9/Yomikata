import SwiftUI

struct MangaRow: View {
    let manga: Manga

    var body: some View {
        NavigationLink(destination: MangaDetailView(manga: manga)) {
            HStack(spacing: 16) {
                MangaMainPicture(
                    url: manga.cleanImageURL,
                    assetName: manga.assetImageName
                )
                .aspectRatio(2 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .frame(width: 65, height: 85)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

                VStack(alignment: .leading, spacing: 4) {
                    Text(manga.displayTitle)
                        .font(.headline)
                        .fontWeight(.medium)
                        .lineLimit(2)

                    Text(manga.displayOriginalTitle)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)

                    // Rating con estrella
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(manga.displayScore)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
            }
        }
    }
}

#Preview {
    List {
        ForEach(Manga.previews) { manga in
            MangaRow(manga: manga)
        }
    }
}
