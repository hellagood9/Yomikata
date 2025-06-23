import SwiftUI

struct ThemeTag: View {
    let theme: Theme
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text(theme.displayName)
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
        ? Color.purple.opacity(0.3)  // Más opaco en dark mode
        : Color.purple.opacity(0.15) // Más claro en light mode
    }
    
    private var textColorForColorScheme: Color {
        return colorScheme == .dark
        ? Color.purple.opacity(0.9) // Casi opaco en dark mode
        : Color.purple             // Color completo en light mode
    }
}


#Preview {
    ThemeTag(theme: Theme(id: "1", theme: "Survival"))
}
