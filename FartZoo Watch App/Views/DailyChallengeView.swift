import SwiftUI

struct DailyChallengeView: View {
    let playerProgress: PlayerProgress
    @Environment(DailyChallengeViewModel.self) private var vm

    var body: some View {
        VStack(spacing: 8) {
            Text("Daily Challenge").font(.headline)

            if vm.completed {
                VStack(spacing: 6) {
                    Text("✅").font(.largeTitle)
                    Text("Done for today!").font(.headline)
                    Text("Come back tomorrow").font(.caption).foregroundStyle(.secondary)
                    Text("+🪙 \(vm.challenge.coinReward) earned").foregroundStyle(.yellow)
                }
            } else {
                VStack(spacing: 6) {
                    Text(vm.challenge.description)
                        .font(.caption)
                        .multilineTextAlignment(.center)

                    ProgressView(value: vm.progressFraction)

                    Text("\(vm.progress) / \(vm.challenge.target)")
                        .font(.caption)

                    Text("Reward: 🪙 \(vm.challenge.coinReward)")
                        .font(.caption)
                        .foregroundStyle(.yellow)

                    Text("FREE — no coins needed")
                        .font(.caption2)
                        .foregroundStyle(.green)

                    if vm.challenge.type == .fartAnimals {
                        Button("Fart! 💨") {
                            vm.recordFart(playerProgress: playerProgress)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.green)
                    } else {
                        Text("Go play to make progress!")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
    }
}
