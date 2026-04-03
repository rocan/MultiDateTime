import Foundation

struct TimezoneSearchService {
    struct SearchResult: Identifiable {
        let id = UUID()
        let identifier: String
        let cityLabel: String
        let regionLabel: String
        let offsetString: String
    }

    func cityLabel(for identifier: String) -> String {
        let parts = identifier.split(separator: "/")
        guard let city = parts.last else { return identifier }
        return city.replacingOccurrences(of: "_", with: " ")
    }

    func regionLabel(for identifier: String) -> String {
        let parts = identifier.split(separator: "/")
        if parts.count >= 2 {
            return String(parts[0]).replacingOccurrences(of: "_", with: " ")
        }
        return ""
    }

    private func offsetString(for identifier: String) -> String {
        guard let tz = TimeZone(identifier: identifier) else { return "" }
        let seconds = tz.secondsFromGMT(for: Date())
        let hours = seconds / 3600
        let minutes = abs(seconds % 3600) / 60
        if minutes == 0 {
            return hours >= 0 ? "UTC+\(hours)" : "UTC\(hours)"
        } else {
            return hours >= 0 ? "UTC+\(hours):\(String(format: "%02d", minutes))" : "UTC\(hours):\(String(format: "%02d", minutes))"
        }
    }

    func search(query: String) -> [SearchResult] {
        let all = TimeZone.knownTimeZoneIdentifiers
        let results: [SearchResult]

        if query.isEmpty {
            results = all.map { identifier in
                SearchResult(
                    identifier: identifier,
                    cityLabel: cityLabel(for: identifier),
                    regionLabel: regionLabel(for: identifier),
                    offsetString: offsetString(for: identifier)
                )
            }
        } else {
            results = all.compactMap { identifier -> SearchResult? in
                let city = cityLabel(for: identifier)
                let region = regionLabel(for: identifier)
                guard city.localizedCaseInsensitiveContains(query)
                    || region.localizedCaseInsensitiveContains(query)
                    || identifier.localizedCaseInsensitiveContains(query)
                else { return nil }
                return SearchResult(
                    identifier: identifier,
                    cityLabel: city,
                    regionLabel: region,
                    offsetString: offsetString(for: identifier)
                )
            }
        }

        return results.sorted { a, b in
            let aPrefix = a.cityLabel.localizedCaseInsensitiveCompare(query) == .orderedSame
            let bPrefix = b.cityLabel.localizedCaseInsensitiveCompare(query) == .orderedSame
            if aPrefix != bPrefix { return aPrefix }
            return a.cityLabel.localizedCompare(b.cityLabel) == .orderedAscending
        }
    }
}
