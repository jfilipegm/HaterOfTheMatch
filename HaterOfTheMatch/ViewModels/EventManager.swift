import Foundation
import Observation

@MainActor
@Observable
final class EventManager {
    var events: [EventCode] = MockEventData.sample

    func create(code: String, matchName: String, competition: String) {
        let event = EventCode(
            id: UUID(),
            code: code.isEmpty ? EventCode.generate() : code.uppercased(),
            matchName: matchName,
            competition: competition,
            createdAt: Date(),
            rageTaps: 0,
            totalBoos: 0,
            villainVotes: 0,
            topVillain: nil
        )
        events.insert(event, at: 0)
    }

    func delete(at offsets: IndexSet) {
        events.remove(atOffsets: offsets)
    }

    func match(for code: String) -> Match {
        MockData.sampleMatches.first(where: \.isLive) ?? MockData.sampleMatches[0]
    }
}
