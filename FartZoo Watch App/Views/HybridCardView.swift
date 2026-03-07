import SwiftUI

struct HybridCardView: View {
    let hybrid: CollectedHybrid
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text(hybrid.emoji)
                    .font(.title2)
                Text(hybrid.name)
                    .font(.caption2)
                    .lineLimit(1)
                if hybrid.count > 1 {
                    Text("x\(hybrid.count)")
                        .font(.caption2)
                        .foregroundStyle(.yellow)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(6)
            .background(Color.orange.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}
