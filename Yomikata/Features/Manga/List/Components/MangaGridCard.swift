import SwiftUI

struct MangaGrid: View {
    let mangas: [Manga]
    let columns: Int
    let spacing: CGFloat
    let onLoadMore: (() async -> Void)?

    init(
        mangas: [Manga],
        columns: Int = 2,
        spacing: CGFloat = 16,
        onLoadMore: (() async -> Void)? = nil
    ) {
        self.mangas = mangas
        self.columns = columns
        self.spacing = spacing
        self.onLoadMore = onLoadMore
    }

    var body: some View {
        GenericGrid(
            items: mangas,
            columns: columns,
            spacing: spacing,
            onLoadMore: onLoadMore
        ) { manga in
            MangaGridCard(manga: manga)
        }
    }
}

struct MangaGridCard: View {
    let manga: Manga

    var body: some View {
        NavigationLink(destination: MangaDetailView(manga: manga)) {
            VStack(alignment: .leading, spacing: 8) {
                MangaMainPicture(
                    url: manga.cleanImageURL,
                    assetName: manga.assetImageName,
                    iconSize: 48
                )
                .aspectRatio(2 / 3, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 6))  // Mismo radio que el List
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)  // Misma sombra que el List

                VStack(alignment: .leading, spacing: 4) {
                    Text(manga.title)
                        .font(.headline)
                        .fontWeight(.medium)  // Mismo weight que el List
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.primary)

                    // RATING
                    if let score = manga.score {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", score))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview("Grid Dark") {
    ScrollView {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
            ],
            spacing: 16
        ) {
            ForEach(0..<6) { _ in
                MangaGridCard(manga: .preview)
            }
        }
        .padding()
    }
    .preferredColorScheme(.dark)
}

#Preview("Grid Light") {
    ScrollView {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
            ],
            spacing: 16
        ) {
            ForEach(0..<6) { _ in
                MangaGridCard(manga: .preview)
            }
        }
        .padding()
    }
    .preferredColorScheme(.light)
}
