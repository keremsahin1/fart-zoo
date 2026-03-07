import XCTest
@testable import FartZoo_Watch_App

/// FartZoo Unit Tests
/// Run with Cmd+U in Xcode on an Apple Watch simulator.
/// Tests are organized by feature:
///   - ModelTests.swift       — Rarity, WorldLocation, HybridAnimal, DailyChallenge
///   - AnimalDatabaseTests.swift — Animal database coverage
///   - TeleportTests.swift    — Teleport location logic
///   - QuestTests.swift       — Quest difficulty scaling and coin economy
///   - FartChefTests.swift    — Hybrid creation logic
///   - DailyChallengeTests.swift — Daily challenge rotation
final class FartZooTests: XCTestCase {
    func test_app_has_animals_in_database() {
        XCTAssertGreaterThan(AnimalDatabase.shared.all.count, 0)
    }

    func test_starting_coins_is_fifty() {
        XCTAssertEqual(PlayerProgress().coins, 50)
    }
}
