import SwiftUI

struct TeleportView: View {
    let playerProgress: PlayerProgress
    @State private var vm = TeleportViewModel()
    @State private var globeRotation: Double = 0
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack(spacing: 8) {
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
                Text(location.displayName)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                let animals = AnimalDatabase.shared.animals(for: location)
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach(animals) { animal in
                            Button {
                                vm.selectAnimal(animal)
                            } label: {
                                HStack {
                                    Text(animal.emoji)
                                    VStack(alignment: .leading) {
                                        Text(animal.name).font(.caption)
                                        Text("🪙 \(animal.rarity.coinCost)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(animal.rarity.displayName)
                                        .font(.caption2)
                                        .foregroundStyle(rarityColor(animal.rarity))
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }

                Button("Teleport Again") { vm.teleport() }
                    .font(.caption)
            } else {
                Button {
                    vm.teleport()
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
        .padding()
        .sheet(isPresented: $vm.showQuest) {
            if let animal = vm.selectedAnimal {
                QuestView(animal: animal, playerProgress: playerProgress)
            }
        }
    }

    private func rarityColor(_ rarity: Rarity) -> Color {
        switch rarity {
        case .common:    return .gray
        case .uncommon:  return .green
        case .rare:      return .blue
        case .legendary: return .purple
        case .extinct:   return .red
        }
    }
}
