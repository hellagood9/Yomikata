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
            .aspectRatio(2 / 3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .frame(width: 65, height: 85)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)

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
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .buttonStyle(.plain)
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onRemove) {
                Label("Remove", systemImage: "bookmark.fill")
            }
        }
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
