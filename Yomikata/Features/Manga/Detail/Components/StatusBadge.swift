import SwiftUI


#Preview {
    HStack {
        StatusBadge(text: "Finalizado", color: .blue)
        StatusBadge(text: "En publicación", color: .green)
        StatusBadge(text: "En pausa", color: .orange)
    }
}
