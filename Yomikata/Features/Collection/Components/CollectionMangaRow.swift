import SwiftUI

struct CollectionMangaRow: View {
    let mangaCollection: MangaCollection
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            MangaMainPicture(
                url: mangaCollection.manga.cleanImageURL,
                assetName: mangaCollection.manga.assetImageName
            )
            .frame(width: 50, height: 70)

            VStack(alignment: .leading, spacing: 4) {
                Text(mangaCollection.manga.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(mangaCollection.progressInfo)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(mangaCollection.purchaseInfo)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Bookmark button para quitar de colección
            Button(action: onRemove) {
                Image(systemName: "bookmark.fill")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        CollectionMangaRow(
            mangaCollection: MangaCollection(
                manga: .preview,
                volumesPurchased: 15,
                currentVolume: 12,
                isCompleteCollection: false
            ),
            onRemove: {}
        )        
    }
}
