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
        ScrollView {
            VStack(spacing: 6) {
                Text(animal.emoji).font(.title2)
                Text(animal.name).font(.headline)
                Text(vm.questType.hint)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Text("Cost: \u{1FA99} \(animal.rarity.coinCost)").font(.caption2)
                Text("You have: \u{1FA99} \(playerProgress.coins)").font(.caption2)
                Button("Catch it!") {
                    vm.startQuest(playerProgress: playerProgress)
                    if vm.questType == .spin && vm.state == .inProgress {
                        challengeVM.recordSpinAttempt(playerProgress: playerProgress)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(playerProgress.coins < animal.rarity.coinCost)
            }
        }
    }

    private var inProgressView: some View {
        Group {
            switch vm.questType {
            case .tap:    tapQuestView
            case .spin:   spinQuestView
            case .timing: timingQuestView
            }
        }
    }

    private var tapQuestView: some View {
        VStack(spacing: 4) {
            Text(animal.emoji).font(.title2)
            ProgressView(value: min(vm.progress, 1.0))
            Text(vm.progressText).font(.headline)
            Text(String(format: "\u{23F1} %.1fs", max(vm.timeRemaining, 0)))
                .font(.caption)
                .foregroundStyle(vm.isTimeWarning ? .red : .primary)
            Button("TAP!") {
                vm.tap(playerProgress: playerProgress)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
    }

    private var spinQuestView: some View {
        VStack(spacing: 4) {
            Text(animal.emoji).font(.title2)
            ProgressView(value: min(vm.progress, 1.0))
            Text(vm.progressText).font(.headline)
            Text(String(format: "\u{23F1} %.1fs", max(vm.timeRemaining, 0)))
                .font(.caption)
                .foregroundStyle(vm.isTimeWarning ? .red : .primary)
            Text("Spin the Crown!")
                .font(.caption)
                .foregroundStyle(.green)
                .fontWeight(.bold)
        }
        .focusable()
        .focused($isCrownFocused)
        .digitalCrownRotation(
            $vm.crownRotation,
            from: -100000, through: 100000,
            sensitivity: .high,
            isContinuous: true
        )
        .onChange(of: vm.crownRotation) { oldValue, newValue in
            vm.handleCrownChange(oldValue: oldValue, newValue: newValue, playerProgress: playerProgress)
        }
        .onAppear {
            isCrownFocused = true
        }
    }

    private var timingQuestView: some View {
        VStack(spacing: 4) {
            Text(vm.isAnimalVisible ? animal.emoji : "💨")
                .font(.largeTitle)
                .animation(.easeInOut(duration: 0.15), value: vm.isAnimalVisible)
            ProgressView(value: min(vm.progress, 1.0))
            Text(vm.progressText).font(.headline)
            Text(String(format: "\u{23F1} %.1fs", max(vm.timeRemaining, 0)))
                .font(.caption)
                .foregroundStyle(vm.isTimeWarning ? .red : .primary)
            Button(vm.isAnimalVisible ? "TAP!" : "WAIT...") {
                vm.timingTap(playerProgress: playerProgress)
            }
            .buttonStyle(.borderedProminent)
            .tint(vm.isAnimalVisible ? .green : .gray)
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
        challengeVM.recordCatch(questType: vm.questType, playerProgress: playerProgress)
    }
}
