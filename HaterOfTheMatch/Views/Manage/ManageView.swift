import SwiftUI

struct ManageView: View {
    @Environment(EventManager.self) private var manager
    @State private var showCreate = false

    var body: some View {
        ZStack {
            Color.haterBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Summary strip
                    HStack(spacing: 0) {
                        summaryTile(value: "\(manager.events.count)", label: "EVENTS")
                        Divider().frame(height: 36).background(Color.white.opacity(0.08))
                        summaryTile(value: "\(manager.events.reduce(0) { $0 + $1.rageTaps })", label: "TOTAL RAGES")
                        Divider().frame(height: 36).background(Color.white.opacity(0.08))
                        summaryTile(value: "\(manager.events.reduce(0) { $0 + $1.totalBoos })", label: "TOTAL BOOS")
                    }
                    .padding(.vertical, 16)
                    .background(Color.haterCard)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 16)

                    // Event list
                    VStack(spacing: 10) {
                        ForEach(manager.events) { event in
                            EventCodeCard(event: event)
                                .padding(.horizontal, 16)
                        }
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("MANAGE EVENTS")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.haterBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showCreate = true
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.haterRed)
                }
            }
        }
        .sheet(isPresented: $showCreate) {
            CreateEventSheet()
                .environment(manager)
        }
    }

    private func summaryTile(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(Color.white)
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color.gray)
                .tracking(1)
        }
        .frame(maxWidth: .infinity)
    }
}

struct EventCodeCard: View {
    let event: EventCode

    private var timeAgo: String {
        let diff = Date().timeIntervalSince(event.createdAt)
        if diff < 3600 { return "\(Int(diff / 60))m ago" }
        if diff < 86400 { return "\(Int(diff / 3600))h ago" }
        return "\(Int(diff / 86400))d ago"
    }

    var body: some View {
        VStack(spacing: 12) {
            // Header row
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(event.code)
                        .font(.system(size: 15, weight: .black, design: .monospaced))
                        .foregroundStyle(Color.haterRed)
                    Text(event.matchName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.white)
                    Text(event.competition)
                        .font(.system(size: 11))
                        .foregroundStyle(Color.gray)
                }
                Spacer()
                Text(timeAgo)
                    .font(.system(size: 10))
                    .foregroundStyle(Color.gray)
            }

            Divider().background(Color.white.opacity(0.06))

            // Stats row
            HStack(spacing: 0) {
                statPill("🔥", value: event.rageTaps, label: "RAGES")
                statPill("👎", value: event.totalBoos, label: "BOOS")
                statPill("💀", value: event.villainVotes, label: "VILLAIN VOTES")
            }

            // Top villain
            if let villain = event.topVillain {
                HStack(spacing: 6) {
                    Text("TOP VILLAIN")
                        .font(.system(size: 9, weight: .black))
                        .foregroundStyle(Color.gray)
                        .tracking(1)
                    Text(villain)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.haterRed)
                    Spacer()
                }
            }
        }
        .padding(14)
        .background(Color.haterCard)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
        )
    }

    private func statPill(_ emoji: String, value: Int, label: String) -> some View {
        VStack(spacing: 3) {
            HStack(spacing: 4) {
                Text(emoji).font(.system(size: 13))
                Text("\(value)")
                    .font(.system(size: 16, weight: .black, design: .rounded))
                    .foregroundStyle(Color.white)
            }
            Text(label)
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(Color.gray)
                .tracking(0.5)
        }
        .frame(maxWidth: .infinity)
    }
}
