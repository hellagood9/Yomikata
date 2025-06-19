import SwiftUI

struct AuthorTag: View {
    let author: Author
    let showRole: Bool

    var body: some View {
        let text =
            showRole
            ? "\(author.fullName) (\(author.displayRole))"
            : author.fullName

        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.1))
            .foregroundColor(.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 6))
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
