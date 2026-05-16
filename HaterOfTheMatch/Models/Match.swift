import Foundation

enum MatchStatus: Equatable {
    case live(minute: Int)
    case finished
    case upcoming(date: Date)

    var isLive: Bool {
        if case .live = self { return true }
        return false
    }

    var label: String {
        switch self {
        case .live(let minute): return "\(minute)'"
        case .finished: return "FT"
        case .upcoming(let date):
            let f = DateFormatter()
            f.timeStyle = .short
            return f.string(from: date)
        }
    }
}

struct Team: Identifiable, Hashable {
    let id: UUID
    let name: String
    let shortName: String
    let badge: String  // emoji stand-in for badge
}

struct Match: Identifiable {
    let id: UUID
    let homeTeam: Team
    let awayTeam: Team
    let homeScore: Int
    let awayScore: Int
    let status: MatchStatus
    let competition: String
    let players: [Player]

    var isLive: Bool { status.isLive }
}
