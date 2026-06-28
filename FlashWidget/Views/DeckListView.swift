import SwiftUI
import WidgetKit

struct DeckListView: View {
    @EnvironmentObject var store: DeckStore
    @State private var showingAdd = false

    private var defaultDecks: [Deck] { store.decks.filter { $0.isDefault } }
    private var userDecks: [Deck]    { store.decks.filter { !$0.isDefault } }

    var body: some View {
        NavigationStack {
            Group {
                if store.decks.isEmpty {
                    emptyState
                } else {
                    List {
                        if !userDecks.isEmpty {
                            Section("My Decks") {
                                ForEach(userDecks) { deck in
                                    NavigationLink(deck.name) {
                                        DeckDetailView(deckId: deck.id)
                                    }
                                }
                                .onDelete { offsets in deleteDecks(offsets, from: userDecks) }
                            }
                        }
                        if !defaultDecks.isEmpty {
                            Section("Default") {
                                ForEach(defaultDecks) { deck in
                                    NavigationLink(deck.name) {
                                        DeckDetailView(deckId: deck.id)
                                    }
                                }
                                .onDelete { offsets in deleteDecks(offsets, from: defaultDecks) }
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
