import SwiftUI
import SwiftData

struct ZooView: View {
    @Query private var collectedAnimals: [CollectedAnimal]
    @Query private var collectedHybrids: [CollectedHybrid]
    @Query private var progressList: [PlayerProgress]
    @Environment(\.modelContext) private var context
    @State private var showTeleport = false
    @State private var showChef = false
    @State private var showDailyChallenge = false

    private var playerProgress: PlayerProgress {
        if let existing = progressList.first { return existing }
        let new = PlayerProgress()
        context.insert(new)
        return new
    }

    private var collectedDefs: [(AnimalDefinition, Int)] {
        collectedAnimals.compactMap { collected in
            guard let def = AnimalDatabase.shared.animal(id: collected.animalID) else { return nil }
            return (def, collected.count)
        }
    }

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    HStack {
                        Text("🪙 \(playerProgress.coins)")
                            .font(.headline)
                        Spacer()
                        Text("\(collectedAnimals.count) animals")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)

                    HStack(spacing: 8) {
                        Button("Teleport!") { showTeleport = true }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)

                        Button("Chef") { showChef = true }
                            .buttonStyle(.bordered)
                    }

                    Button("Daily Challenge") { showDailyChallenge = true }
                        .buttonStyle(.bordered)
                        .tint(.orange)

                    Divider()

                    if collectedDefs.isEmpty {
                        VStack {
                            Text("Welcome to Fart Zoo! 🐾")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            Text("Press Teleport to catch your first animal!")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    } else {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(collectedDefs, id: \.0.id) { (animal, count) in
                                AnimalCardView(animal: animal, count: count) {
                                    SoundManager.shared.playFart(for: animal)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Fart Zoo")
            .sheet(isPresented: $showTeleport) {
                TeleportView(playerProgress: playerProgress)
            }
            .sheet(isPresented: $showChef) {
                FartChefView(playerProgress: playerProgress)
            }
            .sheet(isPresented: $showDailyChallenge) {
                DailyChallengeView(playerProgress: playerProgress)
            }
        }
    }
}
