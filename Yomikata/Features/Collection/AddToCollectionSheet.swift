import SwiftUI

struct AddToCollectionSheet: View {
    let manga: Manga
    @Binding var isPresented: Bool
    var onSave: ([Int], Int?, Bool) -> Void

    var initialVolumes: [Int]? = nil
    var initialReadingVolume: Int? = nil
    var initialComplete: Bool? = nil

    @State private var totalVolumes: Int = 1
    @State private var ownedVolumes: [Int] = []
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
                    ForEach(chunkedVolumes.indices, id: \.self) { index in
                        DisclosureGroup(
                            "collection.volumes".localized()
                                + " \(chunkedVolumes[index].min()!)-\(chunkedVolumes[index].max()!)"
                        ) {
                            ForEach(chunkedVolumes[index], id: \.self) {
                                volume in
                                Toggle(
                                    "collection.volume".localized()
                                        + " \(volume)",
                                    isOn: Binding(
                                        get: { ownedVolumes.contains(volume) },
                                        set: { isOwned in
                                            if isOwned {
                                                ownedVolumes.append(volume)
                                            } else {
                                                ownedVolumes.removeAll {
                                                    $0 == volume
                                                }
                                            }
                                        }
                                    ))
                            }
                        }
                    }
                    Button("collection.select_all".localized()) {
                        ownedVolumes = Array(1...totalVolumes)
                    }
                    Button("collection.deselect_all".localized()) {
                        ownedVolumes.removeAll()
                    }
                }

                Section(header: Text("collection.readingVolume".localized())) {
                    Picker(
                        "collection.current_volume".localized(),
                        selection: $currentVolume
                    ) {
                        ForEach(1...totalVolumes, id: \.self) { volume in
                            Text("collection.volume".localized() + " \(volume)")
                                .tag(volume)
                        }
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
                    Button("button.cancel".localized()) {
                        isPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("button.save".localized()) {
                        onSave(
                            ownedVolumes, currentVolume, isCompleteCollection)
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

    private var chunkedVolumes: [[Int]] {
        let volumes = Array(1...totalVolumes)
        return stride(from: 0, to: volumes.count, by: 6).map {
            Array(volumes[$0..<min($0 + 6, volumes.count)])
        }
    }

    private func updateState() {
        totalVolumes = max(manga.volumes ?? 0, 1)
        ownedVolumes = initialVolumes ?? []
        currentVolume = initialReadingVolume ?? 1
        isCompleteCollection = initialComplete ?? false
    }
}
