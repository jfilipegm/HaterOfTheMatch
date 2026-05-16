import Foundation
import Observation

@MainActor
@Observable
final class HomeViewModel {
    private(set) var matches: [Match] = []
    private(set) var isLoading = false

    var liveMatches: [Match] { matches.filter(\.isLive) }
    var otherMatches: [Match] { matches.filter { !$0.isLive } }

    init() {
        load()
    }

    func load() {
        isLoading = true
        // Simulate network delay
        Task {
            try? await Task.sleep(for: .milliseconds(400))
            matches = MockData.sampleMatches
            isLoading = false
        }
    }
}
