import SwiftUI
import WidgetKit

struct DeckDetailView: View {
    @EnvironmentObject var store: DeckStore
    let deckId: UUID

    @State private var showingAdd = false

    private var deck: Deck? {
        store.decks.first { $0.id == deckId }
    }

    var body: some View {
        Group {
            if let deck {
                Group {
                    if deck.cards.isEmpty {
                        emptyState
                    } else {
                        List {
                            ForEach(deck.cards) { card in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(card.phrase).font(.headline)
                                    Text(card.translation)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .onDelete { offsets in deleteCards(offsets, from: deck) }
                        }
                    }
                }
                .navigationTitle(deck.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                    ToolbarItem(placement: .primaryAction) {
                        Button { showingAdd = true } label: { Image(systemName: "plus") }
                    }
                }
                .sheet(isPresented: $showingAdd) {
                    AddEditCardView(deckId: deckId)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.on.rectangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Cards")
                .font(.headline)
            Text("Add your first card using +")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func deleteCards(_ offsets: IndexSet, from deck: Deck) {
        var updated = deck
        updated.cards.remove(atOffsets: offsets)
        store.updateDeck(updated)
        if WidgetSettings.selectedDeckId == deck.id {
            WidgetSettings.currentCardIndex = 0
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
