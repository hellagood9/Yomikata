import SwiftUI

struct GenreTag: View {
    let genre: Genre
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Tag(
            text: genre.displayName,
            backgroundColor: backgroundColorForColorScheme,
            foregroundColor: textColorForColorScheme
        )
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
