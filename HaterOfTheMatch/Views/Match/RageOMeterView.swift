import SwiftUI

struct RageOMeterView: View {
    let rageLevel: Double  // 0.0–1.0
    let pulse: Bool

    private let lineWidth: CGFloat = 22
    private let startAngle = Angle.degrees(150)
    private let endAngle   = Angle.degrees(30)

    var body: some View {
        ZStack {
            // Track
            Circle()
                .trim(from: 0, to: arcFraction(from: startAngle, to: endAngle))
                .rotation(.degrees(150))
                .stroke(Color.white.opacity(0.08), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))

            // Rage fill
            Circle()
                .trim(from: 0, to: arcFraction(from: startAngle, to: endAngle) * rageLevel)
                .rotation(.degrees(150))
                .stroke(
                    AngularGradient(
                        colors: [Color.haterYellow, Color.haterOrange, Color.haterRed],
                        center: .center,
                        startAngle: .degrees(150),
                        endAngle: .degrees(30)
                    ),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .animation(.spring(duration: 0.6), value: rageLevel)

            // Center content
            VStack(spacing: 4) {
                Text(rageEmoji)
                    .font(.system(size: 44))
                    .scaleEffect(pulse ? 1.25 : 1.0)
                    .animation(.spring(duration: 0.3), value: pulse)
                Text("\(Int(rageLevel * 100))%")
                    .font(.system(size: 42, weight: .black, design: .rounded))
                    .foregroundStyle(Color.white)
                Text("RAGE LEVEL")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(rageColor.opacity(0.8))
                    .tracking(2)
            }
        }
        .frame(width: 240, height: 240)
        .padding(.vertical, 8)
    }

    private func arcFraction(from start: Angle, to end: Angle) -> CGFloat {
        // Arc going clockwise from start, wrapping past 0, to end
        let span = (end.degrees - start.degrees + 360).truncatingRemainder(dividingBy: 360)
        return CGFloat(span / 360)
    }

    private var rageColor: Color {
        if rageLevel < 0.33 { return Color.haterYellow }
        if rageLevel < 0.66 { return Color.haterOrange }
        return Color.haterRed
    }

    private var rageEmoji: String {
        if rageLevel < 0.25 { return "😤" }
        if rageLevel < 0.50 { return "😠" }
        if rageLevel < 0.75 { return "🤬" }
        return "💀"
    }
}
