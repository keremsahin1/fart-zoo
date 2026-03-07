import SwiftUI
import SwiftData

struct FartChefView: View {
    let playerProgress: PlayerProgress
    @Query private var collectedAnimals: [CollectedAnimal]
    @Query private var collectedHybrids: [CollectedHybrid]
    @Environment(\.modelContext) private var context
    @Environment(DailyChallengeViewModel.self) private var challengeVM

    @State private var selectedFirst: String?
    @State private var selectedSecond: String?
    @State private var resultHybrid: CollectedHybrid?
    @State private var showResult = false

    private var eligibleAnimals: [(AnimalDefinition, Int)] {
        collectedAnimals.compactMap { collected in
            guard let def = AnimalDatabase.shared.animal(id: collected.animalID),
                  collected.count >= 1 else { return nil }
            return (def, collected.count)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("Fart Chef").font(.headline)
                Text("Mix two animals!").font(.caption).foregroundStyle(.secondary)

                selectionRow(label: "Animal 1", selectedID: $selectedFirst,
                             excluding: selectedSecond)

                Text("+").font(.title2)

                selectionRow(label: "Animal 2", selectedID: $selectedSecond,
                             excluding: selectedFirst)

                if let id1 = selectedFirst, let id2 = selectedSecond, id1 != id2 {
                    Button("Mix!") { createHybrid(id1: id1, id2: id2) }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                }

                if !collectedHybrids.isEmpty {
                    Divider()
                    Text("Your Hybrids").font(.caption).foregroundStyle(.secondary)
                    ForEach(collectedHybrids) { hybrid in
                        HStack {
                            Text(hybrid.emoji)
                            Text(hybrid.name).font(.caption)
                            Spacer()
                        }
                    }
                }

                if eligibleAnimals.isEmpty {
                    Text("Catch animals first to mix them!")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .sheet(isPresented: $showResult) {
            if let hybrid = resultHybrid {
                hybridResultView(hybrid: hybrid)
            }
        }
    }

    private func selectionRow(label: String, selectedID: Binding<String?>, excluding: String?) -> some View {
        Menu {
            ForEach(eligibleAnimals.filter { $0.0.id != excluding }, id: \.0.id) { (animal, count) in
                Button("\(animal.emoji) \(animal.name) (x\(count))") {
                    selectedID.wrappedValue = animal.id
                }
            }
        } label: {
            HStack {
                if let id = selectedID.wrappedValue,
                   let def = AnimalDatabase.shared.animal(id: id) {
                    Text("\(def.emoji) \(def.name)")
                } else {
                    Text(label).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.down")
            }
            .font(.caption)
            .padding(6)
            .background(Color.secondary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func createHybrid(id1: String, id2: String) {
        guard let def1 = AnimalDatabase.shared.animal(id: id1),
              let def2 = AnimalDatabase.shared.animal(id: id2),
              let collected1 = collectedAnimals.first(where: { $0.animalID == id1 }),
              let collected2 = collectedAnimals.first(where: { $0.animalID == id2 }),
              collected1.count >= 1, collected2.count >= 1 else { return }

        collected1.count -= 1
        collected2.count -= 1

        let hybridID = HybridAnimal.hybridID(parent1ID: id1, parent2ID: id2)
        let name = HybridAnimal.hybridName(parent1: def1.name, parent2: def2.name)
        let emoji = def1.emoji + def2.emoji

        let hybrid = CollectedHybrid(hybridID: hybridID, name: name, emoji: emoji,
                                     parent1ID: id1, parent2ID: id2)
        context.insert(hybrid)
        challengeVM.recordHybrid(playerProgress: playerProgress)
        resultHybrid = hybrid
        selectedFirst = nil
        selectedSecond = nil
        showResult = true
        SoundManager.shared.playVictory()
    }

    private func hybridResultView(hybrid: CollectedHybrid) -> some View {
        VStack(spacing: 8) {
            Text(hybrid.emoji).font(.largeTitle)
            Text("You created a...").font(.caption)
            Text(hybrid.name).font(.headline)
            Text("💨💨💨").font(.title2)
            Button("Amazing!") { showResult = false }
                .buttonStyle(.borderedProminent)
        }
    }
}
