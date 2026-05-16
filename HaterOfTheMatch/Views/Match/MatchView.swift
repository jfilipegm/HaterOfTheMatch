import SwiftUI

struct MatchView: View {
    @Bindable var vm: MatchViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Color.haterBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                matchHeader
                tabBar
                tabContent
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.haterBackground, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Match Header

    private var matchHeader: some View {
        VStack(spacing: 8) {
            Text(vm.match.competition.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color.gray)
                .tracking(2)

            HStack(alignment: .center, spacing: 0) {
                teamBlock(team: vm.match.homeTeam)

                VStack(spacing: 4) {
                    HStack(spacing: 8) {
                        Text("\(vm.match.homeScore)")
                            .font(.system(size: 44, weight: .black, design: .rounded))
                            .foregroundStyle(Color.white)
                        Text("–")
                            .font(.system(size: 30, weight: .thin))
                            .foregroundStyle(Color.gray)
                        Text("\(vm.match.awayScore)")
                            .font(.system(size: 44, weight: .black, design: .rounded))
                            .foregroundStyle(Color.white)
                    }

                    HStack(spacing: 6) {
                        if vm.match.isLive {
                            LivePulseDot()
                        }
                        Text(vm.match.status.label)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(vm.match.isLive ? Color.haterOrange : Color.gray)
                    }
                }
                .frame(maxWidth: .infinity)

                teamBlock(team: vm.match.awayTeam)
            }
        }
        .padding(.top, 8)
        .padding(.bottom, 16)
        .background(Color.haterSurface)
    }

    private func teamBlock(team: Team) -> some View {
        VStack(spacing: 4) {
            Text(team.badge)
                .font(.system(size: 40))
            Text(team.shortName)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Tab Bar

    private var tabBar: some View {
        HStack(spacing: 0) {
            tabItem("🔥", label: "RAGE",    tab: .rage)
            tabItem("👎", label: "RATE",    tab: .rate)
            tabItem("💀", label: "VILLAIN", tab: .villain)
        }
        .background(Color.haterSurface)
        .overlay(Divider().background(Color.white.opacity(0.08)), alignment: .bottom)
    }

    private func tabItem(_ icon: String, label: String, tab: MatchTab) -> some View {
        let selected = vm.selectedTab == tab
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) { vm.select(tab: tab) }
        } label: {
            VStack(spacing: 3) {
                Text(icon).font(.system(size: 18))
                Text(label)
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(selected ? Color.haterRed : Color.gray)
                    .tracking(1)
                Rectangle()
                    .fill(selected ? Color.haterRed : Color.clear)
                    .frame(height: 2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Tab Content

    @ViewBuilder
    private var tabContent: some View {
        switch vm.selectedTab {
        case .rage:
            RageTabView(vm: vm)
        case .rate:
            PlayerRatingView(vm: vm)
        case .villain:
            VillainVoteView(vm: vm)
        }
    }
}
