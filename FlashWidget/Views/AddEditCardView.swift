import SwiftUI
import WidgetKit

struct AddEditCardView: View {
    @EnvironmentObject var store: DeckStore
    @Environment(\.dismiss) var dismiss

    let deckId: UUID

    @State private var phrase = ""
    @State private var translation = ""

    private let phraseLimit = 40
    private let translationLimit = 80

    private var deck: Deck? {
        store.decks.first { $0.id == deckId }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Fráza") {
                    TextField("Fráza", text: $phrase)
                        .onChange(of: phrase) { newValue in
                            if newValue.count > phraseLimit {
                                phrase = String(newValue.prefix(phraseLimit))
                            }
                        }
                    Text("\(phrase.count)/\(phraseLimit)")
                        .font(.caption)
                        .foregroundStyle(phrase.count >= phraseLimit ? .red : .secondary)
                }
                Section("Preklad / Definícia") {
                    TextField("Preklad", text: $translation, axis: .vertical)
                        .lineLimit(3)
                        .onChange(of: translation) { newValue in
                            if newValue.count > translationLimit {
                                translation = String(newValue.prefix(translationLimit))
                            }
                        }
                    Text("\(translation.count)/\(translationLimit)")
                        .font(.caption)
                        .foregroundStyle(translation.count >= translationLimit ? .red : .secondary)
                }
            }
            .navigationTitle("Nová kartička")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušiť") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložiť") {
                        guard var updated = deck else { return }
                        updated.cards.append(Card(phrase: phrase, translation: translation))
                        store.updateDeck(updated)
                        if WidgetSettings.selectedDeckId == deckId {
                            WidgetSettings.currentCardIndex = 0
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                        dismiss()
                    }
                    .disabled(
                        phrase.trimmingCharacters(in: .whitespaces).isEmpty ||
                        translation.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
            }
        }
    }
}
