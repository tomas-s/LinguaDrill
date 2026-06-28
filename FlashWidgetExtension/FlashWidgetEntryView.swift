import SwiftUI
import WidgetKit

struct FlashWidgetEntryView: View {
    let entry: FlashEntry

    var body: some View {
        if entry.isEmpty {
            Text("Select a deck in the app")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        } else {
            VStack(alignment: .leading, spacing: 3) {
                Text(entry.phrase)
                    .font(.title)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(entry.translation)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
