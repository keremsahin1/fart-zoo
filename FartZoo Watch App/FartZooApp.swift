import SwiftUI
import SwiftData

@main
struct FartZooApp: App {
    let container: ModelContainer

    init() {
        let config = ModelConfiguration(
            cloudKitDatabase: .private("iCloud.com.fartzoo.watchkitapp")
        )
        do {
            container = try ModelContainer(
                for: CollectedAnimal.self, CollectedHybrid.self, PlayerProgress.self,
                configurations: config
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        Task.detached(priority: .userInitiated) { _ = GlobeSceneCache.scene }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}

struct RootView: View {
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var context
    @State private var challengeVM: DailyChallengeViewModel?

    private var playerProgress: PlayerProgress {
        if let existing = progressList.first { return existing }
        let new = PlayerProgress()
        context.insert(new)
        return new
    }

    var body: some View {
        if let vm = challengeVM {
            ZooView()
                .environment(vm)
        } else {
            ProgressView()
                .onAppear {
                    challengeVM = DailyChallengeViewModel(playerProgress: playerProgress)
                }
        }
    }
}
