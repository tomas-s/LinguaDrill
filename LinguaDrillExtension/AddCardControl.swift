import AppIntents
import SwiftUI
import WidgetKit

@available(iOS 18.0, *)
struct AddCardControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "com.slizik.linguadrill.addCard") {
            ControlWidgetButton(action: AddCardIntent()) {
                Label("Add Card", systemImage: "plus.rectangle.on.rectangle")
            }
        }
        .displayName("Add Card")
        .description("Add a new card to your active deck.")
    }
}
