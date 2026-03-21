import SwiftUI
import SwiftData
import WatchKit

struct QuestView: View {
    let animal: AnimalDefinition
    let playerProgress: PlayerProgress
    @State private var vm: QuestViewModel
    @FocusState private var isCrownFocused: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(DailyChallengeViewModel.self) private var challengeVM
    @Query private var collectedAnimals: [CollectedAnimal]

    init(animal: AnimalDefinition, playerProgress: PlayerProgress) {
        self.animal = animal
        self.playerProgress = playerProgress
        _vm = State(initialValue: QuestViewModel(animal: animal))
    }

    var body: some View {
        switch vm.state {
        case .choosingQuest:
            choosingQuestView
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

    private var choosingQuestView: some View {
        VStack(spacing: 8) {
            Text(animal.emoji).font(.largeTitle)
            Text(animal.name).font(.headline)
            Text("Choose your quest:").font(.caption).foregroundStyle(.secondary)
            HStack(spacing: 8) {
                ForEach(QuestType.allCases, id: \.self) { type in
                    Button {
                        vm.chooseQuest(type)
                    } label: {
                        VStack(spacing: 2) {
                            Text(type.emoji).font(.title3)
                            Text(type.label).font(.caption2)
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var notStartedView: some View {
        VStack(spacing: 8) {
            Text(animal.emoji).font(.largeTitle)
            Text(animal.name).font(.headline)
            Text("\(vm.questType.emoji) \(vm.questType.label)")
                .font(.caption)
                .foregroundStyle(.secondary)
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
            ProgressView(value: min(vm.progress, 1.0))
            Text(vm.progressText)
                .font(.headline)
            Text(String(format: "\u{23F1} %.1fs", max(vm.timeRemaining, 0)))
                .font(.caption)
                .foregroundStyle(vm.isTimeWarning ? .red : .primary)

            if vm.questType == .tap {
                Button("TAP!") {
                    vm.tap(playerProgress: playerProgress)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            } else {
                Text("Spin the Crown!")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .fontWeight(.bold)
            }
        }
        .focused($isCrownFocused)
        .digitalCrownRotation(
            $vm.crownRotation,
            from: -10000, through: 10000,
            sensitivity: .high,
            isContinuous: true
        )
        .onChange(of: vm.crownRotation) { oldValue, newValue in
            vm.handleCrownChange(oldValue: oldValue, newValue: newValue, playerProgress: playerProgress)
        }
        .onAppear {
            if vm.questType == .spin {
                isCrownFocused = true
            }
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
        challengeVM.recordCatch(playerProgress: playerProgress)
    }
}
