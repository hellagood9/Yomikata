import SwiftUI

struct GenreTag: View {
    let genre: Genre
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Text(genre.displayName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(backgroundColorForColorScheme)
            .foregroundColor(textColorForColorScheme)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var backgroundColorForColorScheme: Color {
        return colorScheme == .dark
            ? Color.indigo.opacity(0.3)
            : Color.indigo.opacity(0.15)
    }

    private var textColorForColorScheme: Color {
        return colorScheme == .dark
            ? Color.indigo.opacity(0.9)
            : Color.indigo
    }
}

#Preview {
    GenreTag(genre: Genre(id: "1", genre: "Action"))
}
