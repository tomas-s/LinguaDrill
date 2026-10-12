import SwiftUI
import WidgetKit

struct LinguaDrillEntryView: View {
    let entry: FlashEntry

    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall, .systemMedium:
            HomeScreenView(entry: entry, isSmall: family == .systemSmall)
                .widgetBackground(homeScreen: true)
        default:
            LockScreenView(entry: entry)
                .widgetBackground(homeScreen: false)
        }
    }
}

private struct LockScreenView: View {
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

private struct HomeScreenView: View {
    let entry: FlashEntry
    let isSmall: Bool

    private let textColor = Color(white: 0.76)

    var body: some View {
        Group {
            if entry.isEmpty {
                Text("Select a deck in the app")
                    .font(.custom("AvenirNext-Italic", size: 15))
                    .foregroundStyle(textColor)
            } else {
                VStack(spacing: isSmall ? 10 : 14) {
                    Text(entry.phrase)
                        .font(.custom("AvenirNext-HeavyItalic", size: isSmall ? 26 : 34))
                        .textCase(.uppercase)
                        .lineLimit(isSmall ? 3 : 2)
                        .minimumScaleFactor(0.4)
                    Text(entry.translation)
                        .font(.custom("AvenirNext-Italic", size: isSmall ? 15 : 19))
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                }
                .foregroundStyle(textColor)
            }
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
