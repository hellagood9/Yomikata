import SwiftUI

struct CollectionMangaRow: View {
    let mangaCollection: MangaCollection
    let onRemove: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            MangaMainPicture(
                url: mangaCollection.manga.cleanImageURL,
                assetName: mangaCollection.manga.assetImageName
            )
            .frame(width: 40, height: 60)

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

            VStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }

                Button(action: onRemove) {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(.accentColor)
                        .frame(width: 32, height: 32)
                        .background(Color.accentColor.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
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
    }
    .listStyle(.plain)
}
