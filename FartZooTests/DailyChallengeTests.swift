import XCTest
@testable import FartZoo_Watch_App

final class DailyChallengeTests: XCTestCase {

    func test_same_day_returns_same_challenge_type() {
        let date = Date()
        let c1 = DailyChallenge.forDate(date)
        let c2 = DailyChallenge.forDate(date)
        XCTAssertEqual(c1.type, c2.type)
    }

    func test_challenge_has_positive_reward() {
        let challenge = DailyChallenge.forDate(Date())
        XCTAssertGreaterThan(challenge.coinReward, 0)
    }

    func test_challenge_has_positive_target() {
        let challenge = DailyChallenge.forDate(Date())
        XCTAssertGreaterThan(challenge.target, 0)
    }

    func test_challenge_description_not_empty() {
        let challenge = DailyChallenge.forDate(Date())
        XCTAssertFalse(challenge.description.isEmpty)
    }

    func test_all_challenge_types_are_reachable() {
        // Verify that iterating through year days covers all challenge types
        let calendar = Calendar.current
        let today = Date()
        var foundTypes = Set<DailyChallengeType>()

        for dayOffset in 0..<(DailyChallengeType.allCases.count) {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                let challenge = DailyChallenge.forDate(date)
                foundTypes.insert(challenge.type)
            }
        }

        XCTAssertEqual(foundTypes.count, DailyChallengeType.allCases.count,
            "All challenge types should be reachable within \(DailyChallengeType.allCases.count) days")
    }
}
