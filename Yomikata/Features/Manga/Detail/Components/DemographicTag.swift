import SwiftUI

struct DemographicTag: View {
    let demographic: String
    
    var body: some View {
        Text(demographic)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(demographicColor.opacity(0.2))
            .foregroundColor(demographicColor)
            .clipShape(Capsule())
    }
    
    private var demographicColor: Color {
        switch demographic.lowercased() {
        case "shounen":
            return .blue
        case "shoujo":
            return .pink
        case "seinen":
            return .purple
        case "josei":
            return .teal
        default:
            return .gray
        }
    }
}

#Preview {
    HStack {
        DemographicTag(demographic: "Seinen")
        DemographicTag(demographic: "Shounen")
        DemographicTag(demographic: "Shoujo")
        DemographicTag(demographic: "Josei")
        DemographicTag(demographic: "Kids")
    }
}
