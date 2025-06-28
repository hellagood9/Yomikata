import SwiftUI

struct Tag: View {
    let text: String
    let backgroundColor: Color
    let foregroundColor: Color
    let font: Font
    let clipShape: AnyShape

    init(
        text: String,
        backgroundColor: Color,
        foregroundColor: Color,
        font: Font = .subheadline,
        clipShape: some Shape = RoundedRectangle(cornerRadius: 8)
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.font = font
        self.clipShape = AnyShape(clipShape)
    }

    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(clipShape)
    }
}

struct AnyShape: Shape, @unchecked Sendable {
    private let _path: @Sendable (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        self._path = { rect in shape.path(in: rect) }
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack(spacing: 12) {
        Tag(
            text: "Sample Tag",
            backgroundColor: .indigo.opacity(0.2),
            foregroundColor: .indigo
        )

        Tag(
            text: "Custom Font & Capsule",
            backgroundColor: .orange.opacity(0.2),
            foregroundColor: .orange,
            font: .caption,
            clipShape: Capsule()
        )

        Tag(
            text: "Another Variant",
            backgroundColor: .green.opacity(0.2),
            foregroundColor: .green,
            clipShape: RoundedRectangle(cornerRadius: 4)
        )
    }
    .padding()
}
