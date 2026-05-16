import Foundation

enum MockData {
    static let manchesterCity = Team(
        id: UUID(uuidString: "11111111-0000-0000-0000-000000000001")!,
        name: "Manchester City",
        shortName: "MCI",
        badge: "🔵"
    )

    static let chelsea = Team(
        id: UUID(uuidString: "11111111-0000-0000-0000-000000000002")!,
        name: "Chelsea",
        shortName: "CHE",
        badge: "🔵"
    )

    static let barcelona = Team(
        id: UUID(uuidString: "11111111-0000-0000-0000-000000000003")!,
        name: "FC Barcelona",
        shortName: "FCB",
        badge: "🔴"
    )

    static let ajax = Team(
        id: UUID(uuidString: "11111111-0000-0000-0000-000000000004")!,
        name: "Ajax",
        shortName: "AJX",
        badge: "⚪"
    )

    static let scBraga = Team(
        id: UUID(uuidString: "11111111-0000-0000-0000-000000000005")!,
        name: "SC Braga",
        shortName: "SCB",
        badge: "🔴"
    )

    static let benfica = Team(
        id: UUID(uuidString: "11111111-0000-0000-0000-000000000006")!,
        name: "SL Benfica",
        shortName: "SLB",
        badge: "🦅"
    )

    static func makePlayers(for team: Team, count: Int = 11) -> [Player] {
        let names: [Position: [String]] = [
            .goalkeeper: ["Ederson", "Raya", "Ter Stegen", "Flekken", "Vlachodimos"],
            .defender: ["Walker", "Silva", "Dias", "Gvardiol", "Chilwell", "Colwill", "Chalobah", "Guiu"],
            .midfielder: ["Rodri", "De Bruyne", "Bernardo", "Kovacic", "Enzo", "Caicedo", "Palmer", "Gündogan"],
            .forward: ["Haaland", "Doku", "Foden", "Jackson", "Sterling", "Mudryk", "Nkunku", "Madueke"]
        ]

        var players: [Player] = []
        var number = 1

        let positions: [Position] = [.goalkeeper, .defender, .defender, .defender, .defender,
                                     .midfielder, .midfielder, .midfielder,
                                     .forward, .forward, .forward]

        for pos in positions.prefix(count) {
            let posNames = names[pos] ?? ["Unknown"]
            let name = posNames[players.count % posNames.count]
            players.append(Player(
                id: UUID(),
                name: name,
                number: number,
                position: pos,
                teamId: team.id,
                boos: 0,
                redCardDemands: 0,
                villainVotes: 0,
                rageRating: 1.0
            ))
            number += 1
        }
        return players
    }

    static var sampleMatches: [Match] {
        let cityPlayers = makePlayers(for: manchesterCity)
        let chelseaPlayers = makePlayers(for: chelsea)
        let barcaPlayers = makePlayers(for: barcelona)
        let ajaxPlayers = makePlayers(for: ajax)
        let bragaPlayers = makePlayers(for: scBraga)
        let benficaPlayers = makePlayers(for: benfica)

        return [
            Match(
                id: UUID(),
                homeTeam: manchesterCity,
                awayTeam: chelsea,
                homeScore: 3,
                awayScore: 1,
                status: .live(minute: 67),
                competition: "Champions League",
                players: cityPlayers + chelseaPlayers
            ),
            Match(
                id: UUID(),
                homeTeam: barcelona,
                awayTeam: ajax,
                homeScore: 2,
                awayScore: 2,
                status: .live(minute: 45),
                competition: "Europa League",
                players: barcaPlayers + ajaxPlayers
            ),
            Match(
                id: UUID(),
                homeTeam: scBraga,
                awayTeam: benfica,
                homeScore: 1,
                awayScore: 2,
                status: .finished,
                competition: "Primeira Liga",
                players: bragaPlayers + benficaPlayers
            ),
            Match(
                id: UUID(),
                homeTeam: chelsea,
                awayTeam: barcelona,
                homeScore: 0,
                awayScore: 0,
                status: .upcoming(date: Date().addingTimeInterval(3600 * 2)),
                competition: "Champions League",
                players: []
            )
        ]
    }
}
