import SwiftUI

struct MatchCardView: View {
    let match: Match

    var body: some View {
        VStack(spacing: 0) {
            // Competition + status header
            HStack {
                Text(match.competition.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color.gray)
                Spacer()
                if match.isLive {
                    HStack(spacing: 5) {
                        LivePulseDot()
                        Text("LIVE")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(Color.haterRed)
                    }
                } else {
                    Text(match.status.label)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)

            // Teams + score
            HStack(alignment: .center, spacing: 0) {
                // Home team
                VStack(spacing: 4) {
                    Text(match.homeTeam.badge)
                        .font(.system(size: 36))
                    Text(match.homeTeam.shortName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)

                // Score
                VStack(spacing: 2) {
                    HStack(spacing: 12) {
                        Text("\(match.homeScore)")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text("–")
                            .font(.system(size: 28, weight: .light))
                            .foregroundStyle(Color.gray)
                        Text("\(match.awayScore)")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundStyle(Color.white)
                    }
                    Text(match.status.label)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(match.isLive ? Color.haterOrange : Color.gray)
                }

                // Away team
                VStack(spacing: 4) {
                    Text(match.awayTeam.badge)
                        .font(.system(size: 36))
                    Text(match.awayTeam.shortName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)

            // Rage bar (only for live / finished)
            if !match.players.isEmpty {
                Divider().background(Color.white.opacity(0.06))
                HStack(spacing: 8) {
                    Text("🔥 RAGE")
                        .font(.system(size: 10, weight: .black))
                        .foregroundStyle(Color.haterOrange)
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.08))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(rageGradient)
                                .frame(width: geo.size.width * match.rageLevel)
                        }
                    }
                    .frame(height: 6)
                    Text("\(Int(match.rageLevel * 100))%")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.haterRed)
                        .frame(width: 32, alignment: .trailing)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
        }
        .background(Color.haterCard)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(match.isLive ? Color.haterRed.opacity(0.4) : Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private var rageGradient: LinearGradient {
        LinearGradient(
            colors: [Color.haterYellow, Color.haterOrange, Color.haterRed],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
