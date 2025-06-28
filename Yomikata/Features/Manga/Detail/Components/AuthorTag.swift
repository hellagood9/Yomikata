import SwiftUI

struct AuthorTag: View {
    let author: Author
    let showRole: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Tag(
            text: tagText,
            backgroundColor: backgroundColorForColorScheme,
            foregroundColor: textColorForColorScheme
        )
    }
    
    private var tagText: String {
        showRole
        ? "\(author.fullName) (\(author.displayRole))"
        : author.fullName
    }
    
    private var backgroundColorForColorScheme: Color {
        colorScheme == .dark
        ? Color.secondary.opacity(0.3)
        : Color.secondary.opacity(0.15)
    }
    
    private var textColorForColorScheme: Color {
        colorScheme == .dark
        ? Color.secondary
        : Color.primary
    }
}

#Preview {
    let mockAuthor = Author(
        id: "1",
        firstName: "Takehiko",
        lastName: "Inoue",
        role: "story & art"
    )
    
    return AuthorTag(author: mockAuthor, showRole: false)
}
