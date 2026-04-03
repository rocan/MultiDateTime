import SwiftUI

struct AddTimezoneView: View {
    @EnvironmentObject var store: ClockStore
    @Environment(\.dismiss) private var dismiss

    @State private var query = ""
    @State private var results: [TimezoneSearchService.SearchResult] = []

    private let searchService = TimezoneSearchService()

    var body: some View {
        NavigationStack {
            List(results) { result in
                Button {
                    store.add(identifier: result.identifier, cityLabel: result.cityLabel)
                    dismiss()
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(result.cityLabel)
                                .foregroundStyle(.primary)
                            if !result.regionLabel.isEmpty {
                                Text(result.regionLabel)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Spacer()
                        Text(result.offsetString)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .disabled(store.entries.contains(where: { $0.timeZoneIdentifier == result.identifier }))
            }
            .navigationTitle("Add Timezone")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .searchable(text: $query, prompt: "Search cities or timezones")
            .onChange(of: query) { _, newValue in
                results = searchService.search(query: newValue)
            }
            .onAppear {
                results = searchService.search(query: "")
            }
        }
    }
}
