import SwiftUI

struct CollectionMangaRow: View {
    let mangaCollection: MangaCollection
    let onRemove: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            MangaMainPicture(
                url: mangaCollection.manga.cleanImageURL,
                assetName: mangaCollection.manga.assetImageName
            )
            .frame(width: 55, height: 75)  // Mismo tamaño que MangaRow
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)  // Misma sombra que MangaRow

            VStack(alignment: .leading, spacing: 4) {
                Text(mangaCollection.manga.title)
                    .font(.headline)
                    .fontWeight(.medium)  // Mismo weight que MangaRow
                    .lineLimit(2)
                    .foregroundColor(.primary)

                // Progress info
                Text(mangaCollection.progressInfo)
                    .font(.footnote)
                    .foregroundColor(.secondary)

                // Purchase info
                Text(mangaCollection.purchaseInfo)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(spacing: 8) {
                // Edit button
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }

                // Remove button (bookmark filled = in collection)
                Button(action: onRemove) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.accentColor)
                        .frame(width: 32, height: 32)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    List {
        CollectionMangaRow(
            mangaCollection: MangaCollection(
                manga: .preview,
                volumesOwned: Array(1...15),
                readingVolume: 12,
                completeCollection: false
            ),
            onRemove: {},
            onEdit: {}
        )

        CollectionMangaRow(
            mangaCollection: MangaCollection(
                manga: .preview,
                volumesOwned: Array(1...12),
                readingVolume: 12,
                completeCollection: true
            ),
            onRemove: {},
            onEdit: {}
        )
    }
    .listStyle(.plain)
}
