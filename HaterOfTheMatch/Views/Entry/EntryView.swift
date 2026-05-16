import SwiftUI

enum EntryMode { case rage, manage }

struct EntryView: View {
    @Environment(EventManager.self) private var manager
    @State private var mode: EntryMode = .rage
    @State private var eventId = "UCL2024-067"
    @State private var matchVM: MatchViewModel?
    @State private var navigateToMatch = false
    @State private var navigateToManage = false
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

                    // Bottom card
                    VStack(spacing: 16) {

                        // Segmented picker
                        HStack(spacing: 0) {
                            segmentButton("RAGE", mode: .rage)
                            segmentButton("MANAGE", mode: .manage)
                        }
                        .background(Color.haterCard)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        // Content per mode
                        if mode == .rage {
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
                            .transition(.opacity.combined(with: .move(edge: .leading)))
                        } else {
                            HStack(spacing: 10) {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundStyle(Color.haterRed)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(manager.events.count) active events")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundStyle(Color.white)
                                    Text("View codes, stats and create new events")
                                        .font(.system(size: 11))
                                        .foregroundStyle(Color.gray)
                                }
                                Spacer()
                            }
                            .padding(14)
                            .background(Color.haterCard)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                        }

                        // Action button
                        Button(action: primaryAction) {
                            Text(mode == .rage ? "ENTER THE HATE" : "OPEN MANAGER")
                                .font(.system(size: 15, weight: .black))
                                .tracking(2)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(actionEnabled ? Color.haterRed : Color.white.opacity(0.07))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .disabled(!actionEnabled)
                        .animation(.easeInOut(duration: 0.2), value: actionEnabled)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 52)
                    .animation(.easeInOut(duration: 0.2), value: mode)
                }
            }
            .navigationDestination(isPresented: $navigateToMatch) {
                if let vm = matchVM { MatchView(vm: vm) }
            }
            .navigationDestination(isPresented: $navigateToManage) {
                ManageView().environment(manager)
            }
            .toolbarBackground(Color.haterBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - Helpers

    private var actionEnabled: Bool {
        mode == .manage || !eventId.isEmpty
    }

    private func primaryAction() {
        if mode == .manage {
            navigateToManage = true
        } else {
            enter()
        }
    }

    private func enter() {
        guard !eventId.isEmpty else { return }
        let match = MockData.sampleMatches.first(where: \.isLive) ?? MockData.sampleMatches[0]
        matchVM = MatchViewModel(match: match)
        navigateToMatch = true
    }

    private func segmentButton(_ label: String, mode target: EntryMode) -> some View {
        let selected = mode == target
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) { mode = target }
        } label: {
            Text(label)
                .font(.system(size: 13, weight: .black))
                .tracking(2)
                .foregroundStyle(selected ? Color.white : Color.gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(selected ? Color.haterRed : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(3)
        }
        .buttonStyle(.plain)
    }
}
