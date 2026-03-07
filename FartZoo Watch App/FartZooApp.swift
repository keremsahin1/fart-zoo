import SwiftUI
import SwiftData

@main
struct FartZooApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [CollectedAnimal.self, CollectedHybrid.self, PlayerProgress.self])
    }
}

struct RootView: View {
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var context

    private var playerProgress: PlayerProgress {
        if let existing = progressList.first { return existing }
        let new = PlayerProgress()
        context.insert(new)
        return new
    }

    var body: some View {
        ZooView()
    }
}
