import SwiftUI

struct AddToCollectionSheet: View {
    let manga: Manga
    @Binding var isPresented: Bool
    var onSave: (Int, Int?, Bool) -> Void

    var initialVolumes: Int? = nil
    var initialReadingVolume: Int? = nil
    var initialComplete: Bool? = nil

    @State private var totalVolumes: Int = 1
    @State private var volumesPurchased: Int = 0
    @State private var currentVolume: Int = 1
    @State private var isCompleteCollection = false

    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Text("collection.totalVolumes".localized())
                    Spacer()
                    Text("\(totalVolumes)")
                        .foregroundStyle(.secondary)
                }

                Section(header: Text("collection.volumesPurchased".localized()))
                {
                    Stepper(
                        value: $volumesPurchased, in: 0...max(totalVolumes, 1)
                    ) {
                        Text("\(volumesPurchased)")
                    }
                }

                Section(header: Text("collection.readingVolume".localized())) {
                    Stepper(value: $currentVolume, in: 1...max(totalVolumes, 1))
                    {
                        Text("\(currentVolume)")
                    }
                }

                Section {
                    Toggle(
                        "collection.isComplete".localized(),
                        isOn: $isCompleteCollection)
                }
            }
            .navigationTitle("collection.add.title".localized())
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("button.cancel".localized(fallback: "Cancel")) {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("button.save".localized(fallback: "Save")) {
                        onSave(
                            volumesPurchased, currentVolume,
                            isCompleteCollection)
                        isPresented = false
                    }
                }
            }
            .onAppear {
                updateState()
            }
            .onChange(of: isPresented) {
                updateState()
            }
        }
    }

    private func updateState() {
        totalVolumes = max(manga.volumes ?? 0, 1)
        volumesPurchased = initialVolumes ?? min(1, totalVolumes)
        currentVolume = initialReadingVolume ?? 1
        isCompleteCollection = initialComplete ?? false
    }
}

#Preview {
    @Previewable @State var show = true

    return AddToCollectionSheet(
        manga: .preview,
        isPresented: $show,
        onSave: { _, _, _ in }
    )
}
