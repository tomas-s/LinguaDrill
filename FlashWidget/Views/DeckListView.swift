import SwiftUI
import WidgetKit

struct DeckListView: View {
    @EnvironmentObject var store: DeckStore
    @State private var showingAdd = false

    var body: some View {
        NavigationStack {
            Group {
                if store.decks.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(store.decks) { deck in
                            NavigationLink(deck.name) {
                                DeckDetailView(deckId: deck.id)
                            }
                        }
                        .onDelete { offsets in deleteDecks(offsets, from: store.decks) }
                    }
                }
            }
            .navigationTitle("Decks")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { EditButton() }
                ToolbarItem(placement: .primaryAction) {
                    Button { showingAdd = true } label: { Image(systemName: "plus") }
                }
            }
            .sheet(isPresented: $showingAdd) {
                AddEditDeckView()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "rectangle.stack")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Decks")
                .font(.headline)
            Text("Add your first deck using +")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func deleteDecks(_ offsets: IndexSet, from source: [Deck]) {
        let ids = offsets.map { source[$0].id }
        ids.forEach { id in
            store.deleteDeck(id: id)
            if WidgetSettings.selectedDeckId == id {
                WidgetSettings.selectedDeckId = nil
                WidgetSettings.currentCardIndex = 0
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
