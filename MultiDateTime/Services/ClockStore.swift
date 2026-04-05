import Foundation
import SwiftUI
#if !WIDGET_EXTENSION
import WidgetKit
#endif

class ClockStore: ObservableObject {
    static let suiteName = "group.com.zzc.multidatetime"
    static let entriesKey = "wc.entries"
    static let formatKey = "wc.timeFormat"

    @Published var entries: [ClockEntry] = []
    @Published var timeFormat: TimeFormat = .twelveHour

    private let defaults: UserDefaults

    init() {
        self.defaults = UserDefaults(suiteName: Self.suiteName) ?? .standard
        load()
        if entries.isEmpty {
            seedDefaults()
        }
    }

    private func seedDefaults() {
        let seeds: [(identifier: String, city: String)] = [
            ("America/New_York", "New York"),
            ("Europe/London", "London"),
            ("Asia/Tokyo", "Tokyo"),
        ]
        entries = seeds.enumerated().map { index, seed in
            ClockEntry(
                timeZoneIdentifier: seed.identifier,
                cityLabel: seed.city,
                airportCode: ClockEntry.iataCode(for: seed.identifier) ?? String(seed.city.prefix(3)).uppercased(),
                sortOrder: index
            )
        }
        persist()
    }

    private func load() {
        if let data = defaults.data(forKey: Self.entriesKey),
           let decoded = try? JSONDecoder().decode([ClockEntry].self, from: data) {
            entries = decoded.sorted { $0.sortOrder < $1.sortOrder }
        }
        if let raw = defaults.string(forKey: Self.formatKey),
           let format = TimeFormat(rawValue: raw) {
            timeFormat = format
        }
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(entries) {
            defaults.set(data, forKey: Self.entriesKey)
        }
        defaults.set(timeFormat.rawValue, forKey: Self.formatKey)
#if !WIDGET_EXTENSION
        WidgetCenter.shared.reloadAllTimelines()
#endif
    }

    func add(identifier: String, cityLabel: String) {
        guard !entries.contains(where: { $0.timeZoneIdentifier == identifier }) else { return }
        let entry = ClockEntry(
            timeZoneIdentifier: identifier,
            cityLabel: cityLabel,
            airportCode: ClockEntry.iataCode(for: identifier) ?? String(cityLabel.prefix(3)).uppercased(),
            sortOrder: entries.count
        )
        entries.append(entry)
        persist()
    }

    func remove(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        for (index, _) in entries.enumerated() {
            entries[index].sortOrder = index
        }
        persist()
    }

    func move(from source: IndexSet, to destination: Int) {
        entries.move(fromOffsets: source, toOffset: destination)
        for (index, _) in entries.enumerated() {
            entries[index].sortOrder = index
        }
        persist()
    }

    func setTimeFormat(_ format: TimeFormat) {
        timeFormat = format
        persist()
    }
}
