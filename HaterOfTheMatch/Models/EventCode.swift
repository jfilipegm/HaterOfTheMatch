import Foundation

struct EventCode: Identifiable {
    let id: UUID
    var code: String
    var matchName: String
    var competition: String
    let createdAt: Date
    var rageTaps: Int
    var totalBoos: Int
    var villainVotes: Int
    var topVillain: String?

    var totalActivity: Int { rageTaps + totalBoos + villainVotes }

    static func generate() -> String {
        let prefix = ["UCL", "PL", "PL1", "UEL", "SCB", "CL"].randomElement()!
        let year = 2024
        let number = Int.random(in: 1...999)
        return "\(prefix)\(year)-\(String(format: "%03d", number))"
    }
}

enum MockEventData {
    static let sample: [EventCode] = [
        EventCode(
            id: UUID(),
            code: "UCL2024-067",
            matchName: "Man City vs Chelsea",
            competition: "Champions League",
            createdAt: Date().addingTimeInterval(-3600 * 2),
            rageTaps: 0,
            totalBoos: 0,
            villainVotes: 0,
            topVillain: nil
        ),
        EventCode(
            id: UUID(),
            code: "PL2024-112",
            matchName: "Barcelona vs Ajax",
            competition: "Europa League",
            createdAt: Date().addingTimeInterval(-3600 * 24),
            rageTaps: 142,
            totalBoos: 38,
            villainVotes: 11,
            topVillain: "Ederson"
        ),
        EventCode(
            id: UUID(),
            code: "SCB2024-089",
            matchName: "SC Braga vs Benfica",
            competition: "Primeira Liga",
            createdAt: Date().addingTimeInterval(-3600 * 48),
            rageTaps: 89,
            totalBoos: 21,
            villainVotes: 7,
            topVillain: "Silva"
        )
    ]
}
