import SwiftUI
import WidgetKit

struct DeckListView: View {
    @EnvironmentObject var store: DeckStore
    @State private var showingAdd = false
    @State private var activeDeckId: UUID? = WidgetSettings.selectedDeckId

    var body: some View {
        NavigationStack {
            Group {
                if store.decks.isEmpty {
                    emptyState
                } else {
                    List {
                        if !activeDecks.isEmpty {
                            Section("Active Deck") {
                                deckRows(activeDecks)
                            }
                        }
                        if !inactiveDecks.isEmpty {
                            Section("Inactive Decks") {
                                deckRows(inactiveDecks)
                            }
                        }
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
            .onAppear { activeDeckId = WidgetSettings.selectedDeckId }
        }
    }

    private var activeDecks: [Deck] {
        store.decks.filter { $0.id == activeDeckId }
    }

    private var inactiveDecks: [Deck] {
        store.decks.filter { $0.id != activeDeckId }
    }

    private func deckRows(_ decks: [Deck]) -> some View {
        ForEach(decks) { deck in
            NavigationLink {
                DeckDetailView(deckId: deck.id)
            } label: {
                deckRow(deck)
            }
            .listRowBackground(deck.id == activeDeckId ? Color.accentColor.opacity(0.15) : nil)
        }
        .onDelete { offsets in deleteDecks(offsets, from: decks) }
    }

    private func deckRow(_ deck: Deck) -> some View {
        Text(deck.name)
            .fontWeight(deck.id == activeDeckId ? .semibold : .regular)
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
                activeDeckId = nil
                WidgetSettings.currentCardIndex = 0
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
