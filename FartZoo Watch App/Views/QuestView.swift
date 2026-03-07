import SwiftUI
struct QuestView: View {
    let animal: AnimalDefinition
    let playerProgress: PlayerProgress
    var body: some View { Text("Quest coming soon for \(animal.name)") }
}
