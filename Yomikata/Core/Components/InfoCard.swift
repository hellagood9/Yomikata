import SwiftUI

struct InfoCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
            }

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    HStack {
        InfoCard(title: "Followers", value: "123K", icon: "person.crop.circle")
        InfoCard(title: "Likes", value: "456", icon: "hand.thumbsup")
        InfoCard(title: "Views", value: "789", icon: "eye")
    }
}
