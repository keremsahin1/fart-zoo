import SwiftUI

struct TeleportView: View {
    let playerProgress: PlayerProgress
    @State private var vm = TeleportViewModel()
    @State private var globeRotation: Double = 0
    @Environment(\.modelContext) private var context
    @Environment(DailyChallengeViewModel.self) private var challengeVM

    var body: some View {
        Group {
            if vm.isAnimating {
                VStack {
                    Text("🌍")
                        .font(.largeTitle)
                        .rotationEffect(.degrees(globeRotation))
                        .onAppear {
                            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                                globeRotation = 360
                            }
                        }
                    Text("Teleporting...")
                        .font(.caption)
                }
            } else if let location = vm.currentLocation {
                VStack(spacing: 0) {
                    Text(location.displayName)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 2)
                        .padding(.bottom, 1)
                        .padding(.horizontal)

                    ScrollView {
                        VStack(spacing: 2) {
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

                    Button("Teleport Again") {
                        globeRotation = 0
                        vm.teleport()
                        challengeVM.recordTeleport(playerProgress: playerProgress)
                    }
                    .font(.caption2)
                    .padding(.top, 2)
                    .padding(.bottom, 4)
                }
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
        .sheet(isPresented: $vm.showQuest) {
            if let animal = vm.selectedAnimal {
                QuestView(animal: animal, playerProgress: playerProgress)
            }
        }
    }

}
