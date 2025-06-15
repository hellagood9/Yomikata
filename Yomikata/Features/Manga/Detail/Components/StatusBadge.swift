import SwiftUI

struct StatusBadge: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    HStack {
        StatusBadge(text: "Finalizado", color: .blue)
        StatusBadge(text: "En publicación", color: .green)
        StatusBadge(text: "En pausa", color: .orange)
    }
}
