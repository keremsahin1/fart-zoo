import SwiftUI

struct DailyChallengeView: View {
    let playerProgress: PlayerProgress
    @Environment(DailyChallengeViewModel.self) private var vm

    var body: some View {
        ScrollView {
            VStack(spacing: 6) {
                ForEach(Array(vm.challenges.enumerated()), id: \.offset) { index, challenge in
                    challengeRow(index: index, challenge: challenge)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 6)
        }
    }

    private func challengeRow(index: Int, challenge: DailyChallenge) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .top) {
                Text(vm.isCompleted(index) ? "✅" : typeEmoji(challenge.type))
                    .font(.caption)
                Text(challenge.description)
                    .font(.caption2)
                    .lineLimit(2)
                Spacer()
                Text("🪙\(challenge.coinReward)")
                    .font(.caption2)
                    .foregroundStyle(.yellow)
            }

            if vm.isCompleted(index) {
                Text("Done!")
                    .font(.caption2)
                    .foregroundStyle(.green)
            } else {
                ProgressView(value: vm.progressFraction(for: index))
                    .tint(progressColor(vm.progressFraction(for: index)))
                HStack {
                    Text("\(vm.progressValues[index]) / \(challenge.target)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    if challenge.type == .fartAnimals {
                        Button("Fart! 💨") {
                            let animals = AnimalDatabase.shared.all
                            let random = animals[Int.random(in: 0..<animals.count)]
                            SoundManager.shared.playFart(for: random)
                            vm.recordFart(playerProgress: playerProgress)
                        }
                        .font(.caption2)
                        .buttonStyle(.bordered)
                    }
                }
            }
        }
        .padding(6)
        .background(vm.isCompleted(index) ? Color.green.opacity(0.12) : Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func typeEmoji(_ type: DailyChallengeType) -> String {
        switch type {
        case .fartAnimals:  return "💨"
        case .teleport:     return "🌍"
        case .catchAnimals: return "🎯"
        case .makeHybrid:   return "🧪"
        }
    }

    private func progressColor(_ fraction: Double) -> Color {
        fraction >= 1 ? .green : fraction >= 0.5 ? .yellow : .blue
    }
}
