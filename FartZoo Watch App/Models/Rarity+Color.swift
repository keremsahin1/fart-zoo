import SwiftUI

extension Rarity {
    var color: Color {
        switch self {
        case .common:    return .gray
        case .uncommon:  return .green
        case .rare:      return .blue
        case .legendary: return .purple
        case .extinct:   return .red
        }
    }
}

extension ProgressColor {
    var color: Color {
        switch self {
        case .green:  return .green
        case .yellow: return .yellow
        case .blue:   return .blue
        }
    }
}
