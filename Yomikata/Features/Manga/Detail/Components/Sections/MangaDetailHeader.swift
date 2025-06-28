import SwiftUI

struct MangaDetailHeader: View {
    let manga: Manga
    @Environment(\.colorScheme) var colorScheme  // Detecta el modo del device

    var body: some View {
        ZStack {
            // Background que va hasta el top
            MangaMainPicture(
                url: manga.cleanImageURL,
                assetName: manga.assetImageName
            )
            .aspectRatio(contentMode: .fill)
            .frame(height: 380)
            .clipped()
            .opacity(0.4)
            .overlay(
                // Degradado que se adapta al color scheme
                LinearGradient(
                    colors: [
                        (colorScheme == .dark ? Color.black : Color.white)
                            .opacity(0.8),
                        (colorScheme == .dark ? Color.black : Color.white)
                            .opacity(0.4),
//                        Color.clear,  // Transparente arriba
                        Color.clear,  // Transparente en el medio
                        // Adapta según el modo: negro para dark, blanco para light
                        (colorScheme == .dark ? Color.black : Color.white)
                            .opacity(0.8),
                        (colorScheme == .dark ? Color.black : Color.white)  // Color sólido al final,
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )

            // Contenido centrado
            VStack(spacing: 16) {
                Spacer()

                // Portada principal
                MangaMainPicture(
                    url: manga.cleanImageURL,
                    assetName: manga.assetImageName
                )
                .frame(width: 120, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)

                // Info básica
                VStack(spacing: 8) {
                    Text(manga.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(
                            colorScheme == .dark ? .white : .black
                        )  // Adapta el texto
                        .multilineTextAlignment(.center)

                    Text(
                        manga.authors.joinedStringValues(
                            separator: " • ", keyPath: \.fullName)
                    )
                    .font(.subheadline)
                    .foregroundColor(
                        (colorScheme == .dark ? Color.white : .black).opacity(
                            0.8)
                    )
                    .multilineTextAlignment(.center)

                    HStack(spacing: 12) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(manga.displayScore)
                                .fontWeight(.medium)
                                .foregroundColor(
                                    colorScheme == .dark ? .white : .black)
                        }
                        .font(.subheadline)

                        StatusBadge(
                            text: manga.statusDisplay, color: manga.statusColor)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .padding(.top, 100)
        }
        .frame(height: 350)
    }
}

#Preview {
    MangaDetailHeader(manga: .preview)
        .preferredColorScheme(.dark)
}
