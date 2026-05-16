import Foundation
import Observation

enum MatchTab {
    case rage, rate, villain
}

@MainActor
@Observable
final class MatchViewModel {
    private(set) var match: Match
    private(set) var selectedTab: MatchTab = .rage
    private(set) var villainVote: Player.ID? = nil
    private(set) var ragePulse = false
    var rageLevel: Double { match.rageLevel }

    var homePlayers: [Player] { match.players.filter { $0.teamId == match.homeTeam.id } }
    var awayPlayers: [Player] { match.players.filter { $0.teamId == match.awayTeam.id } }
    var sortedByHate: [Player] { match.players.sorted { $0.totalHate > $1.totalHate } }

    init(match: Match) {
        self.match = match
    }

    func select(tab: MatchTab) {
        selectedTab = tab
    }

    func boo(player: Player) {
        update(player: player) { $0.boos += 1 }
        pulse()
    }

    func demandRedCard(for player: Player) {
        update(player: player) { $0.redCardDemands += 1 }
        pulse()
    }

    func setRating(_ rating: Double, for player: Player) {
        update(player: player) { $0.rageRating = rating }
    }

    func voteVillain(_ player: Player) {
        if villainVote == player.id {
            villainVote = nil
            update(player: player) { $0.villainVotes = max(0, $0.villainVotes - 1) }
        } else {
            if let prev = villainVote, let prevPlayer = match.players.first(where: { $0.id == prev }) {
                update(player: prevPlayer) { $0.villainVotes = max(0, $0.villainVotes - 1) }
            }
            villainVote = player.id
            update(player: player) { $0.villainVotes += 1 }
        }
        pulse()
    }

    func quickRage(type: QuickRageType) {
        var topVictim = sortedByHate.first
        switch type {
        case .boo:
            if let p = topVictim { boo(player: p) }
        case .redCard:
            if let p = topVictim { demandRedCard(for: p) }
        case .dive:
            topVictim = match.players.randomElement()
            if let p = topVictim { boo(player: p) }
        case .offside:
            topVictim = match.players.randomElement()
            if let p = topVictim { boo(player: p) }
        }
    }

    private func update(player: Player, mutation: (inout Player) -> Void) {
        guard let idx = match.players.firstIndex(where: { $0.id == player.id }) else { return }
        let updated = match
        var updatedPlayers = updated.players
        mutation(&updatedPlayers[idx])
        match = Match(
            id: updated.id,
            homeTeam: updated.homeTeam,
            awayTeam: updated.awayTeam,
            homeScore: updated.homeScore,
            awayScore: updated.awayScore,
            status: updated.status,
            competition: updated.competition,
            players: updatedPlayers
        )
    }

    private func pulse() {
        ragePulse = true
        Task {
            try? await Task.sleep(for: .milliseconds(300))
            ragePulse = false
        }
    }
}

enum QuickRageType {
    case boo, redCard, dive, offside

    var label: String {
        switch self {
        case .boo:     return "BOO!"
        case .redCard: return "RED CARD!"
        case .dive:    return "DIVE!"
        case .offside: return "OFFSIDE!"
        }
    }

    var emoji: String {
        switch self {
        case .boo:     return "👎"
        case .redCard: return "🟥"
        case .dive:    return "🤿"
        case .offside: return "🚩"
        }
    }
}
