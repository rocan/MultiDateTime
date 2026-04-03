import SwiftUI

struct ClockRowView: View {
    let entry: ClockEntry
    let timeFormat: TimeFormat

    var body: some View {
        HStack {
            Text(entry.cityLabel)
                .font(.headline)
            Spacer()
            LiveTimeText(entry: entry, timeFormat: timeFormat)
        }
        .padding(.vertical, 4)
    }
}
