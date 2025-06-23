import SwiftUI

struct MangaRow: View {
    let manga: Manga

    var body: some View {
        NavigationLink(destination: MangaDetailView(manga: manga)) {
            HStack {
                MangaMainPicture(
                    url: manga.cleanImageURL,
                    assetName: manga.assetImageName
                )
                .frame(width: 50, height: 70)

                VStack(alignment: .leading, spacing: 4) {
                    Text(manga.displayTitle)
                        .font(.headline)
                        .lineLimit(2)

                    Text(manga.displayOriginalTitle)
                        .font(.footnote)
                        .lineLimit(2)
                        .foregroundColor(.secondary)

                    Text(manga.displayScore)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                Spacer()
            }
            .padding(.vertical, 4)
        }

    }
}

#Preview {
    List {
        MangaRow(manga: .preview)
    }
}
