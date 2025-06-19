import SwiftUI

struct FlowLayout<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let horizontalSpacing: CGFloat
    let content: (Data.Element) -> Content
    
    @State private var sizes: [String: CGSize] = [:]
    @State private var height: CGFloat = .zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateWrappedRows(width: geometry.size.width)
                    .background(HeightReader(height: $height))
                    .animation(.easeInOut, value: sizes) // animación suave
            }
        }
        .frame(height: height)
    }
    
    private func generateWrappedRows(width totalWidth: CGFloat) -> some View {
        var rows: [[Data.Element]] = []
        var currentRow: [Data.Element] = []
        var currentWidth: CGFloat = 0
        
        for item in data {
            let key = "\(item.hashValue)"
            let itemSize = sizes[key, default: .zero]
            let itemWidth = itemSize.width + horizontalSpacing
            
            if currentWidth + itemWidth > totalWidth {
                rows.append(currentRow)
                currentRow = [item]
                currentWidth = itemWidth
            } else {
                currentRow.append(item)
                currentWidth += itemWidth
            }
        }
        
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: horizontalSpacing) {
                    ForEach(rows[rowIndex], id: \.self) { item in
                        content(item)
                            .fixedSize()
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(
                                            key: SizePreferenceKey.self,
                                            value: ["\(item.hashValue)": geo.size]
                                        )
                                }
                            )
                    }
                }
            }
        }
        .onPreferenceChange(SizePreferenceKey.self) { self.sizes = $0 }
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGSize] = [:]
    static func reduce(value: inout [String: CGSize], nextValue: () -> [String: CGSize]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

private struct HeightReader: View {
    @Binding var height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    height = geometry.size.height
                }
                .onChange(of: geometry.size.height) {
                    height = geometry.size.height
                }
        }
    }
}
