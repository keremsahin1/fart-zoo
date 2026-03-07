import SwiftUI
import SwiftData
import WatchKit

struct QuestView: View {
    let animal: AnimalDefinition
    let playerProgress: PlayerProgress
    @State private var vm: QuestViewModel
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var collectedAnimals: [CollectedAnimal]

    init(animal: AnimalDefinition, playerProgress: PlayerProgress) {
        self.animal = animal
        self.playerProgress = playerProgress
        _vm = State(initialValue: QuestViewModel(animal: animal))
    }

    var body: some View {
        switch vm.state {
        case .notStarted:
            notStartedView
        case .inProgress:
            inProgressView
        case .won:
            wonView
        case .lost:
            lostView
        case .insufficientCoins:
            insufficientCoinsView
        }
    }

    private var notStartedView: some View {
        VStack(spacing: 8) {
            Text(animal.emoji).font(.largeTitle)
            Text(animal.name).font(.headline)
            Text("Cost: \u{1FA99} \(animal.rarity.coinCost)").font(.caption)
            Text("You have: \u{1FA99} \(playerProgress.coins)").font(.caption)
            Button("Catch it!") {
                vm.startQuest(playerProgress: playerProgress)
            }
            .buttonStyle(.borderedProminent)
            .disabled(playerProgress.coins < animal.rarity.coinCost)
        }
    }

    private var inProgressView: some View {
        VStack(spacing: 4) {
            Text(animal.emoji).font(.title2)
            ProgressView(value: Double(vm.tapCount), total: Double(vm.tapTarget))
            Text("\(vm.tapCount) / \(vm.tapTarget)")
                .font(.headline)
            Text(String(format: "\u{23F1} %.1fs", max(vm.timeRemaining, 0)))
                .font(.caption)
                .foregroundStyle(vm.timeRemaining < 3 ? .red : .primary)
            Button("TAP!") {
                vm.tap(playerProgress: playerProgress)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
    }

    private var wonView: some View {
        VStack(spacing: 8) {
            Text("\u{1F389}").font(.largeTitle)
            Text("You caught \(animal.name)!").font(.headline)
            Text("+\u{1FA99} \(animal.rarity.coinReward)").foregroundStyle(.yellow)
            Button("Back to Zoo") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear { addAnimalToCollection() }
    }

    private var lostView: some View {
        VStack(spacing: 8) {
            Text("\u{1F4A8}").font(.largeTitle)
            Text("\(animal.name) escaped!").font(.headline)
            Text("Coins lost: \u{1FA99} \(animal.rarity.coinCost)").foregroundStyle(.red)
            Button("Try Again") {
                vm = QuestViewModel(animal: animal)
            }
            Button("Give Up") { dismiss() }
                .foregroundStyle(.secondary)
        }
    }

    private var insufficientCoinsView: some View {
        VStack(spacing: 8) {
            Text("\u{1FA99}").font(.largeTitle)
            Text("Not enough coins!").font(.headline)
            Text("Need \(animal.rarity.coinCost), have \(playerProgress.coins)")
                .font(.caption)
                .multilineTextAlignment(.center)
            Button("OK") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
    }

    private func addAnimalToCollection() {
        if let existing = collectedAnimals.first(where: { $0.animalID == animal.id }) {
            existing.count += 1
        } else {
            context.insert(CollectedAnimal(animalID: animal.id))
        }
    }
}
