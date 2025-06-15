import SwiftUI

struct ThemeTag: View {
    let theme: Theme

    var body: some View {
        Text(theme.displayName)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.purple.opacity(0.1))
            .foregroundColor(.purple)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    ThemeTag(theme: Theme(id: "1", theme: "Survival"))
}
