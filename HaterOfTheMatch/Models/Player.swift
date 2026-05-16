import Foundation

enum Position: String, CaseIterable {
    case goalkeeper = "GK"
    case defender = "DEF"
    case midfielder = "MID"
    case forward = "FWD"
}

struct Player: Identifiable, Hashable {
    let id: UUID
    let name: String
    let number: Int
    let position: Position
    let teamId: UUID
    var boos: Int
    var redCardDemands: Int
    var villainVotes: Int
    var rageRating: Double  // 1–10; higher = worse performance

    var rageEmoji: String {
        switch rageRating {
        case 0..<3: return "😤"
        case 3..<5: return "😠"
        case 5..<7: return "🤬"
        case 7..<9: return "💀"
        default:    return "☠️"
        }
    }

    var totalHate: Int { boos + redCardDemands * 3 + villainVotes * 5 }
}
