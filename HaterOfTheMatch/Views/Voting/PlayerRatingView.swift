import SwiftUI

struct PlayerRatingView: View {
    @Bindable var vm: MatchViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(vm.match.players) { player in
                    PlayerRatingCard(player: player) { rating in
                        vm.setRating(rating, for: player)
                    } onBoo: {
                        vm.boo(player: player)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct PlayerRatingCard: View {
    let player: Player
    let onRate: (Double) -> Void
    let onBoo: () -> Void

    @State private var rating: Double
    @State private var booCount: Int
    @State private var booTapped = false

    init(player: Player, onRate: @escaping (Double) -> Void, onBoo: @escaping () -> Void) {
        self.player = player
        self.onRate = onRate
        self.onBoo = onBoo
        self._rating = State(initialValue: player.rageRating)
        self._booCount = State(initialValue: player.boos)
    }

    var body: some View {
        VStack(spacing: 10) {
            // Position + number row
            HStack {
                Text(player.position.rawValue)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Color.gray)
                Spacer()
                Text("#\(player.number)")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(Color.gray)
            }

            // Emoji
            Text(rageEmoji)
                .font(.system(size: 44))
                .animation(.spring(duration: 0.3), value: rageEmoji)

            // Name
            Text(player.name)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            // Rating number
            Text(String(format: "%.1f", rating))
                .font(.system(size: 20, weight: .black, design: .rounded))
                .foregroundStyle(ratingColor)
                .animation(.easeInOut(duration: 0.15), value: ratingColor)

            // Slider
            Slider(value: $rating, in: 1...10, step: 0.5)
                .tint(ratingColor)
                .onChange(of: rating) { _, new in onRate(new) }

            // Boo button
            Button {
                booTapped = true
                booCount += 1
                onBoo()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { booTapped = false }
            } label: {
                HStack(spacing: 5) {
                    Text("👎")
                        .font(.system(size: 14))
                    Text("\(booCount)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(Color.white)
                        .contentTransition(.numericText())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(booTapped ? Color.haterRed.opacity(0.25) : Color.haterSurface)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .scaleEffect(booTapped ? 0.95 : 1.0)
            .animation(.spring(duration: 0.15), value: booTapped)
        }
        .padding(12)
        .background(Color.haterCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var ratingEmoji: String {
        switch rating {
        case 0..<3: return "😤"
        case 3..<5: return "😠"
        case 5..<7: return "🤬"
        case 7..<9: return "💀"
        default:    return "☠️"
        }
    }

    // Keep emoji in sync with local slider state (not player.rageEmoji which lags)
    private var rageEmoji: String { ratingEmoji }

    private var ratingColor: Color {
        if rating < 4 { return Color.haterYellow }
        if rating < 7 { return Color.haterOrange }
        return Color.haterRed
    }
}
