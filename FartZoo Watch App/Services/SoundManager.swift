import AVFoundation
import WatchKit

class SoundManager {
    static let shared = SoundManager()
    private init() {}
    private var player: AVAudioPlayer?

    func play(soundFile: String) {
        guard let url = Bundle.main.url(forResource: soundFile, withExtension: "wav") else {
            print("Sound file not found: \(soundFile).wav")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Failed to play sound: \(error)")
        }
    }

    func playFart(for animal: AnimalDefinition) {
        play(soundFile: animal.soundFile)
        WKInterfaceDevice.current().play(.click)
    }

    func playHybridFart(parent1ID: String, parent2ID: String) {
        guard let parent1 = AnimalDatabase.shared.animal(id: parent1ID),
              let parent2 = AnimalDatabase.shared.animal(id: parent2ID) else { return }
        play(soundFile: parent1.soundFile)
        WKInterfaceDevice.current().play(.click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.play(soundFile: parent2.soundFile)
            WKInterfaceDevice.current().play(.click)
        }
    }

    func playVictory() {
        WKInterfaceDevice.current().play(.success)
    }

    func playFailure() {
        WKInterfaceDevice.current().play(.failure)
    }

    func playTeleport() {
        WKInterfaceDevice.current().play(.directionUp)
    }
}
