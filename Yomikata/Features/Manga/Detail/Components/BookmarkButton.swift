import SwiftUI

struct BookmarkButton: View {
    let isBookmarked: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3)) {
                action()
            }
        }) {
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.title3)
                .foregroundColor(isBookmarked ? .accentColor : .gray)
        }
    }
}

#Preview {
    HStack {
        BookmarkButton(isBookmarked: false, action: {})
        BookmarkButton(isBookmarked: true, action: {})
    }
}
