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
    @State private var booTapped = false

    init(player: Player, onRate: @escaping (Double) -> Void, onBoo: @escaping () -> Void) {
        self.player = player
        self.onRate = onRate
        self.onBoo = onBoo
        self._rating = State(initialValue: player.rageRating)
    }

    var body: some View {
        VStack(spacing: 8) {
            // Number badge + position
            HStack {
                Text(player.position.rawValue)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Color.haterSurface)
                    .clipShape(Capsule())
                Spacer()
                Text("#\(player.number)")
                    .font(.system(size: 12, weight: .black))
                    .foregroundStyle(Color.gray)
            }

            // Emoji + name
            Text(player.rageEmoji)
                .font(.system(size: 36))
            Text(player.name)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            // Rage rating slider
            VStack(spacing: 4) {
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(ratingColor)
                Slider(value: $rating, in: 1...10, step: 0.5)
                    .tint(ratingColor)
                    .onChange(of: rating) { _, new in onRate(new) }
            }

            // Boo button
            Button {
                booTapped = true
                onBoo()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { booTapped = false }
            } label: {
                HStack(spacing: 4) {
                    Text("👎")
                    Text("\(player.boos)")
                        .font(.system(size: 12, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(booTapped ? Color.haterRed.opacity(0.3) : Color.haterSurface)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .scaleEffect(booTapped ? 0.95 : 1.0)
            .animation(.spring(duration: 0.15), value: booTapped)
        }
        .padding(12)
        .background(Color.haterCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(ratingColor.opacity(0.3), lineWidth: 1)
        )
    }

    private var ratingColor: Color {
        if rating < 4 { return Color.haterYellow }
        if rating < 7 { return Color.haterOrange }
        return Color.haterRed
    }
}
