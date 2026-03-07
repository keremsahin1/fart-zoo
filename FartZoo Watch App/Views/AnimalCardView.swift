import SwiftUI

struct AnimalCardView: View {
    let animal: AnimalDefinition
    let count: Int
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text(animal.emoji)
                    .font(.title2)
                Text(animal.name)
                    .font(.caption2)
                    .lineLimit(1)
                if count > 1 {
                    Text("x\(count)")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(6)
            .background(animal.rarity.color.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
