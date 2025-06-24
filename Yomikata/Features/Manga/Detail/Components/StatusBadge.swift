import SwiftUI

// Status badge que respeta el color scheme con mejor contraste
struct StatusBadge: View {
    let text: String
    let color: Color
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(textColorForColorScheme)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColorForColorScheme)
            )
    }

    private var backgroundColorForColorScheme: Color {
        return colorScheme == .dark
            ? color.opacity(0.3)  // Más opaco en dark mode
            : color.opacity(0.15)  // Más claro en light mode
    }

    private var textColorForColorScheme: Color {
        return colorScheme == .dark
            ? color.opacity(0.9)  // Casi opaco en dark mode
            : color  // Color completo en light mode
    }
}

#Preview("Status Badges") {
    VStack(spacing: 16) {
        HStack {
            StatusBadge(text: "Finished", color: .blue)
            StatusBadge(text: "Publishing", color: .green)
            StatusBadge(text: "On Hiatus", color: .orange)
        }     
    }
    .padding()
}
