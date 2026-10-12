import SwiftUI

/// Entry point for adding a card from the Action Button or Shortcuts.
/// Goes straight to the form for the active deck, otherwise asks which deck to use.
struct QuickAddCardView: View {
    @EnvironmentObject var store: DeckStore
    @Environment(\.dismiss) var dismiss

    @State private var pickedDeckId: UUID?

    private var activeDeckId: UUID? {
        guard let id = WidgetSettings.selectedDeckId,
              store.decks.contains(where: { $0.id == id }) else { return nil }
        return id
    }

    var body: some View {
        if let deckId = activeDeckId ?? pickedDeckId {
            AddEditCardView(deckId: deckId)
        } else {
            deckPicker
        }
    }

    private var deckPicker: some View {
        NavigationStack {
            Group {
                if store.decks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "rectangle.stack")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("No Decks")
                            .font(.headline)
                        Text("Create a deck first to add cards.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List(store.decks) { deck in
                        Button(deck.name) { pickedDeckId = deck.id }
                            .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Choose Deck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
