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
                .widgetBackground()
        }
        .configurationDisplayName("Flash Card")
        .description("Zobrazí aktuálnu kartičku z tvojho decku.")
        .supportedFamilies([.accessoryRectangular])
    }
}

extension View {
    @ViewBuilder
    func widgetBackground() -> some View {
        if #available(iOS 17, *) {
            self.containerBackground(.fill.tertiary, for: .widget)
        } else {
            self
        }
    }
}
