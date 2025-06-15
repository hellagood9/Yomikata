import SwiftUI

struct GenreTag: View {
    let genre: Genre

    var body: some View {
        Text(genre.displayName)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    GenreTag(genre: Genre(id: "1", genre: "Action"))
}
