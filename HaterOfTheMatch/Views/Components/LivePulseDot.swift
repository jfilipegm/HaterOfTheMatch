import SwiftUI

struct LivePulseDot: View {
    @State private var scale = 1.0

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.haterRed.opacity(0.3))
                .frame(width: 16, height: 16)
                .scaleEffect(scale)
            Circle()
                .fill(Color.haterRed)
                .frame(width: 8, height: 8)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                scale = 1.6
            }
        }
    }
}
