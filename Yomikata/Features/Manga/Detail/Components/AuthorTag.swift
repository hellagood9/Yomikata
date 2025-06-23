import SwiftUI

struct AuthorTag: View {
    let author: Author
    let showRole: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let text = showRole
        ? "\(author.fullName) (\(author.displayRole))"
        : author.fullName
        
        Text(text)
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
        ? Color.secondary.opacity(0.3)
        : Color.secondary.opacity(0.15)
    }
    
    private var textColorForColorScheme: Color {
        return colorScheme == .dark
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
