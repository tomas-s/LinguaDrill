import AppIntents

struct LinguaDrillShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddCardIntent(),
            phrases: [
                "Add card in \(.applicationName)",
                "New \(.applicationName) card"
            ],
            shortTitle: "Add Card",
            systemImageName: "plus.rectangle.on.rectangle"
        )
    }
}
