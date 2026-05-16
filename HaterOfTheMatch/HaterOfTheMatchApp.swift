import SwiftUI

@main
struct HaterOfTheMatchApp: App {
    @State private var eventManager = EventManager()

    var body: some Scene {
        WindowGroup {
            EntryView()
                .environment(eventManager)
                .preferredColorScheme(.dark)
        }
    }
}
