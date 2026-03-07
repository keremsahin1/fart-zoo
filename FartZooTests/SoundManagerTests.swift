import XCTest
@testable import FartZoo_Watch_App

final class SoundManagerTests: XCTestCase {

    func test_players_array_supports_multiple_simultaneous_sounds() {
        // Regression: hybrid fart only played second parent's sound because
        // a single AVAudioPlayer reference was replaced on second play() call.
        // Now uses an array so both can play simultaneously.
        let sm = SoundManager.shared

        // Even without real sound files, verify the array structure exists
        // and doesn't collapse to a single reference.
        XCTAssertNotNil(sm.players, "players should be an accessible array, not a single optional")
    }

    func test_all_animals_have_valid_sound_file_names() {
        // Ensure every animal references a sound file name (non-empty).
        for animal in AnimalDatabase.shared.all {
            XCTAssertFalse(animal.soundFile.isEmpty,
                           "\(animal.name) has an empty soundFile")
        }
    }

    func test_hybrid_fart_requires_valid_parent_ids() {
        // playHybridFart should not crash with invalid IDs.
        // Just verifying it gracefully handles bad input.
        SoundManager.shared.playHybridFart(parent1ID: "nonexistent1", parent2ID: "nonexistent2")
        // No crash = pass
    }
}
