import WidgetKit
import SwiftUI

@main
struct FlashWidgetBundle: WidgetBundle {
    var body: some Widget {
        FlashWidget()
    }
}

struct FlashWidget: Widget {
    let kind = "FlashWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FlashProvider()) { entry in
            FlashWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Flash Card")
        .description("Shows the current card from your deck.")
        .supportedFamilies([.accessoryRectangular, .systemSmall, .systemMedium])
    }
}

extension View {
    @ViewBuilder
    func widgetBackground(homeScreen: Bool) -> some View {
        if #available(iOS 17, *) {
            if homeScreen {
                self.containerBackground(Color.black, for: .widget)
            } else {
                self.containerBackground(.fill.tertiary, for: .widget)
            }
        } else if homeScreen {
            self.background(Color.black)
        } else {
            self
        }
    }
}
