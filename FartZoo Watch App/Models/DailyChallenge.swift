import Foundation

enum DailyChallengeType: String, CaseIterable, Codable {
    case fartAnimals
    case teleport
    case catchAnimals
    case makeHybrid
    case spinCatch
    case spinMaster
    case winWithBoth

    var emoji: String {
        switch self {
        case .fartAnimals:  return "💨"
        case .teleport:     return "🌍"
        case .catchAnimals: return "🎯"
        case .makeHybrid:   return "🧪"
        case .spinCatch:    return "🌀"
        case .spinMaster:   return "💫"
        case .winWithBoth:  return "🏆"
        }
    }
}

enum ProgressColor: String {
    case green, yellow, blue

    static func from(fraction: Double) -> ProgressColor {
        fraction >= 1 ? .green : fraction >= 0.5 ? .yellow : .blue
    }
}

struct DailyChallenge {
    let type: DailyChallengeType
    let target: Int
    let coinReward: Int
    let description: String

    // Pool of 15 challenges — 5 are picked per day, shifting by 1 each day
    static let pool: [DailyChallenge] = [
        DailyChallenge(type: .fartAnimals,  target: 10, coinReward: 15, description: "Fart 10 times"),
        DailyChallenge(type: .teleport,     target: 3,  coinReward: 15, description: "Teleport 3 times"),
        DailyChallenge(type: .catchAnimals, target: 1,  coinReward: 20, description: "Catch 1 animal"),
        DailyChallenge(type: .spinCatch,    target: 1,  coinReward: 25, description: "Catch 1 animal using Spin"),
        DailyChallenge(type: .fartAnimals,  target: 25, coinReward: 25, description: "Fart 25 times"),
        DailyChallenge(type: .teleport,     target: 5,  coinReward: 20, description: "Teleport 5 times"),
        DailyChallenge(type: .catchAnimals, target: 2,  coinReward: 30, description: "Catch 2 animals"),
        DailyChallenge(type: .makeHybrid,   target: 1,  coinReward: 35, description: "Make a hybrid"),
        DailyChallenge(type: .spinMaster,   target: 5,  coinReward: 30, description: "Do 5 spin quests"),
        DailyChallenge(type: .fartAnimals,  target: 40, coinReward: 35, description: "Fart 40 times"),
        DailyChallenge(type: .teleport,     target: 8,  coinReward: 30, description: "Teleport 8 times"),
        DailyChallenge(type: .winWithBoth,  target: 2,  coinReward: 40, description: "Catch using Tap AND Spin"),
        DailyChallenge(type: .catchAnimals, target: 3,  coinReward: 40, description: "Catch 3 animals"),
        DailyChallenge(type: .spinCatch,    target: 2,  coinReward: 35, description: "Catch 2 animals using Spin"),
        DailyChallenge(type: .spinMaster,   target: 10, coinReward: 40, description: "Do 10 spin quests"),
    ]

    static func allForDate(_ date: Date) -> [DailyChallenge] {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: date) ?? 1
        let offset = (day - 1) % pool.count
        return (0..<5).map { i in pool[(offset + i) % pool.count] }
    }
}
