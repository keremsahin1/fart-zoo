import SwiftUI

struct TeleportView: View {
    let playerProgress: PlayerProgress
    @State private var vm = TeleportViewModel()
    @Environment(\.modelContext) private var context
    @Environment(DailyChallengeViewModel.self) private var challengeVM

    var body: some View {
        NavigationStack {
            VStack {
                if vm.isAnimating {
                    SpinningGlobeView()
                    Text("Teleporting...")
                        .font(.caption)
                } else {
                    Button {
                        vm.teleport()
                        challengeVM.recordTeleport(playerProgress: playerProgress)
                    } label: {
                        VStack {
                            Text("🌍")
                                .font(.largeTitle)
                            Text("Teleport!")
                                .font(.headline)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationDestination(isPresented: $vm.showAnimalList) {
                animalListView
            }
        }
        .sheet(isPresented: $vm.showQuest) {
            if let animal = vm.selectedAnimal {
                QuestView(animal: animal, playerProgress: playerProgress)
            }
        }
    }

    private var animalListView: some View {
        ScrollView {
            VStack(spacing: 2) {
                Text(vm.currentLocation?.displayName ?? "")
                    .font(.caption2)
                    .foregroundStyle(.secondary)

                ForEach(vm.shuffledAnimals) { animal in
                    Button {
                        vm.selectAnimal(animal)
                    } label: {
                        HStack {
                            Text(animal.emoji)
                            VStack(alignment: .leading, spacing: 0) {
                                Text(animal.name).font(.caption)
                                Text("🪙 \(animal.rarity.coinCost)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(animal.rarity.displayName)
                                .font(.caption2)
                                .foregroundStyle(animal.rarity.color)
                        }
                        .padding(.horizontal, 6)
                    }
                    .buttonStyle(.bordered)
                    .padding(.horizontal, 4)
                }
            }
            .padding(.vertical, 2)
        }
    }
}
