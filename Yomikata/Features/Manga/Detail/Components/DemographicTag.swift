import SwiftUI

struct DemographicTag: View {
    let demographic: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {  
        Tag(
            text: demographic,
            backgroundColor: backgroundColorForColorScheme,
            foregroundColor: textColorForColorScheme,
            clipShape: Capsule()
        )
    }
    
    private var backgroundColorForColorScheme: Color {
        let baseColor = demographicColor
        return colorScheme == .dark
        ? baseColor.opacity(0.3)
        : baseColor.opacity(0.15)
    }
    
    private var textColorForColorScheme: Color {
        return colorScheme == .dark
        ? demographicColor.opacity(0.9)
        : demographicColor
    }
    
    private var demographicColor: Color {
        switch demographic.lowercased() {
        case "shounen":
            return .blue
        case "shoujo":
            return .pink
        case "seinen":
            return .orange
        case "josei":
            return .teal
        default:
            return .secondary
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
