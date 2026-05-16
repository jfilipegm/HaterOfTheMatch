import SwiftUI

struct EntryView: View {
    @State private var eventId = "UCL2024-067"
    @State private var matchVM: MatchViewModel?
    @State private var navigate = false
    @State private var logoScale = 0.6
    @State private var logoOpacity = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color.haterBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    // Logo
                    VStack(spacing: 20) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 280, height: 280)
                            .scaleEffect(logoScale)
                            .opacity(logoOpacity)
                            .onAppear {
                                withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                                    logoScale = 1.0
                                    logoOpacity = 1.0
                                }
                            }

                        Text("vent. rate. destroy.")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.gray)
                            .italic()
                    }

                    Spacer()

                    // Input
                    VStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("EVENT ID")
                                .font(.system(size: 11, weight: .black))
                                .foregroundStyle(Color.gray)
                                .tracking(3)

                            TextField(
                                "",
                                text: $eventId,
                                prompt: Text("e.g. UCL2024-067")
                                    .foregroundStyle(Color.gray.opacity(0.35))
                            )
                            .font(.system(size: 17, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color.white)
                            .padding(16)
                            .background(Color.haterCard)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(
                                        eventId.isEmpty
                                            ? Color.white.opacity(0.08)
                                            : Color.haterRed.opacity(0.7),
                                        lineWidth: 1.5
                                    )
                            )
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.asciiCapable)
                            .onSubmit { enter() }
                        }

                        Button(action: enter) {
                            Text("ENTER THE HATE")
                                .font(.system(size: 15, weight: .black))
                                .tracking(2)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(
                                    eventId.isEmpty
                                        ? Color.white.opacity(0.07)
                                        : Color.haterRed
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(eventId.isEmpty)
                        .animation(.easeInOut(duration: 0.2), value: eventId.isEmpty)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 52)
                }
            }
            .navigationDestination(isPresented: $navigate) {
                if let vm = matchVM {
                    MatchView(vm: vm)
                }
            }
            .toolbarBackground(Color.haterBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private func enter() {
        guard !eventId.isEmpty else { return }
        // Demo: any event ID resolves to a mock live match
        let match = MockData.sampleMatches.first(where: \.isLive) ?? MockData.sampleMatches[0]
        matchVM = MatchViewModel(match: match)
        navigate = true
    }
}
