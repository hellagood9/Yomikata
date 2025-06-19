import SwiftUI

struct MangaGridCard: View {
    let manga: Manga

    var body: some View {
        NavigationLink(destination: MangaDetailView(manga: manga)) {
            VStack(alignment: .leading, spacing: 8) {
                // Imagen más grande para grid
                MangaMainPicture(
                    url: manga.cleanImageURL,
                    assetName: manga.assetImageName,
                    iconSize: 48
                )
                .aspectRatio(2 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                // Info compacta
                VStack(alignment: .leading, spacing: 2) {
                    Text(manga.title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if let score = manga.score {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", score))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        MangaGridCard(manga: .preview)
        MangaGridCard(manga: .preview)
    }
    .padding()
}
