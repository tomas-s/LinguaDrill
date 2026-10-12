import SwiftUI
import WidgetKit

struct AddEditCardView: View {
    @EnvironmentObject var store: DeckStore
    @Environment(\.dismiss) var dismiss

    let deckId: UUID

    @State private var phrase = ""
    @State private var translation = ""
    @FocusState private var phraseFocused: Bool

    private let phraseLimit = 40
    private let translationLimit = 80

    private var deck: Deck? {
        store.decks.first { $0.id == deckId }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Phrase") {
                    HStack(alignment: .center) {
                        TextField("Phrase", text: $phrase)
                            .textInputAutocapitalization(.never)
                            .focused($phraseFocused)
                            .onChange(of: phrase) { newValue in
                                let normalized = newValue.lowercasingFirstLetter()
                                let capped = normalized.count > phraseLimit
                                    ? String(normalized.prefix(phraseLimit))
                                    : normalized
                                if capped != phrase { phrase = capped }
                            }
                        Spacer()
                        Text("\(phrase.count)/\(phraseLimit)")
                            .font(.caption)
                            .foregroundStyle(phrase.count >= phraseLimit ? .red : .secondary)
                            .monospacedDigit()
                    }
                }
                Section("Translation / Definition") {
                    HStack(alignment: .top) {
                        TextField("Translation", text: $translation, axis: .vertical)
                            .lineLimit(3)
                            .textInputAutocapitalization(.never)
                            .onChange(of: translation) { newValue in
                                let normalized = newValue.lowercasingFirstLetter()
                                let capped = normalized.count > translationLimit
                                    ? String(normalized.prefix(translationLimit))
                                    : normalized
                                if capped != translation { translation = capped }
                            }
                        Text("\(translation.count)/\(translationLimit)")
                            .font(.caption)
                            .foregroundStyle(translation.count >= translationLimit ? .red : .secondary)
                            .monospacedDigit()
                    }
                }
            }
            .onAppear { phraseFocused = true }
            .navigationTitle("New Card")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
