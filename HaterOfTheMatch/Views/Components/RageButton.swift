import SwiftUI

struct RageButton: View {
    let type: QuickRageType
    let action: () -> Void
    @State private var tapped = false

    var body: some View {
        Button(action: {
            tapped = true
            action()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { tapped = false }
        }) {
            VStack(spacing: 4) {
                Text(type.emoji)
                    .font(.system(size: 28))
                Text(type.label)
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(Color.haterRed)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.haterCard)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(tapped ? Color.haterRed : Color.clear, lineWidth: 1.5)
            )
            .scaleEffect(tapped ? 0.93 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.15), value: tapped)
    }
}
