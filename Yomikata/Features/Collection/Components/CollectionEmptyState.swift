import SwiftUI

struct CollectionEmptyState: View {
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "bookmark")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text("collection.title".localized(fallback: "Your Collection"))
                .font(.title2)
            
            Text("collection.empty.message".localized(fallback: "You don't have any saved mangas yet"))
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    CollectionEmptyState()
}
