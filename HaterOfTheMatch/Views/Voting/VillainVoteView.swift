import SwiftUI

struct VillainVoteView: View {
    @Bindable var vm: MatchViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Header callout
                VStack(spacing: 6) {
                    Text("💀")
                        .font(.system(size: 48))
                    Text("VILLAIN OF THE MATCH")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(Color.white)
                    Text("Who ruined the match? Cast your vote.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)

                Divider().background(Color.white.opacity(0.06))

                // Player list sorted by villain votes
                ForEach(vm.sortedByHate) { player in
                    VillainVoteRow(
                        player: player,
                        isVoted: vm.villainVote == player.id,
                        totalVotes: vm.match.players.reduce(0) { $0 + $1.villainVotes }
                    ) {
                        vm.voteVillain(player)
                    }
                    .padding(.horizontal, 16)
                }

                Spacer(minLength: 32)
            }
        }
    }
}

struct VillainVoteRow: View {
    let player: Player
    let isVoted: Bool
    let totalVotes: Int
    let action: () -> Void

    private var votePercent: Double {
        guard totalVotes > 0 else { return 0 }
        return Double(player.villainVotes) / Double(totalVotes)
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    // Position badge
                    Text(player.position.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.gray)
                        .frame(width: 32)

                    // Emoji + name
                    Text(player.rageEmoji)
                        .font(.system(size: 24))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(player.name)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.white)
                        Text("\(player.villainVotes) votes · \(Int(votePercent * 100))%")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray)
                    }

                    Spacer()

                    // Vote checkmark / skull
                    Image(systemName: isVoted ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .foregroundStyle(isVoted ? Color.haterRed : Color.gray.opacity(0.4))
                }

                // Vote bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.white.opacity(0.06))
                        RoundedRectangle(cornerRadius: 3)
                            .fill(isVoted ? Color.haterRed : Color.haterOrange.opacity(0.5))
                            .frame(width: max(6, geo.size.width * votePercent))
                            .animation(.spring(duration: 0.4), value: votePercent)
                    }
                }
                .frame(height: 5)
            }
            .padding(14)
            .background(isVoted ? Color.haterRed.opacity(0.12) : Color.haterCard)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isVoted ? Color.haterRed.opacity(0.6) : Color.white.opacity(0.06),
                        lineWidth: isVoted ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.25), value: isVoted)
    }
}
