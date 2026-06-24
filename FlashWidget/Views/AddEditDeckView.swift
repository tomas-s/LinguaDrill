import SwiftUI

struct AddEditDeckView: View {
    @EnvironmentObject var store: DeckStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Názov decku", text: $name)
            }
            .navigationTitle("Nový deck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Zrušiť") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Uložiť") {
                        store.addDeck(Deck(name: name.trimmingCharacters(in: .whitespaces)))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
