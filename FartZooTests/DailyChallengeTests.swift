import XCTest
@testable import FartZoo_Watch_App

final class DailyChallengeTests: XCTestCase {

    func test_same_day_returns_same_challenges() {
        let date = Date()
        let c1 = DailyChallenge.allForDate(date)
        let c2 = DailyChallenge.allForDate(date)
        XCTAssertEqual(c1.map { $0.type }, c2.map { $0.type })
    }

    func test_returns_exactly_5_challenges() {
        XCTAssertEqual(DailyChallenge.allForDate(Date()).count, 5)
    }

    func test_all_challenges_have_positive_reward() {
        for challenge in DailyChallenge.allForDate(Date()) {
            XCTAssertGreaterThan(challenge.coinReward, 0)
        }
    }

    func test_all_challenges_have_positive_target() {
        for challenge in DailyChallenge.allForDate(Date()) {
            XCTAssertGreaterThan(challenge.target, 0)
        }
    }

    func test_all_challenges_have_non_empty_description() {
        for challenge in DailyChallenge.allForDate(Date()) {
            XCTAssertFalse(challenge.description.isEmpty)
        }
    }

    func test_different_days_return_different_challenges() {
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        let todayChallenges = DailyChallenge.allForDate(today).map { $0.description }
        let tomorrowChallenges = DailyChallenge.allForDate(tomorrow).map { $0.description }
        XCTAssertNotEqual(todayChallenges, tomorrowChallenges)
    }

    func test_pool_has_all_challenge_types() {
        let types = Set(DailyChallenge.pool.map { $0.type })
        for type in DailyChallengeType.allCases {
            XCTAssertTrue(types.contains(type), "Pool missing challenge type: \(type)")
        }
    }
}
