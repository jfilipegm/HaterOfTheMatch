import SwiftUI

struct HomeView: View {
    @State private var vm = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.haterBackground.ignoresSafeArea()

                if vm.isLoading {
                    ProgressView()
                        .tint(Color.haterRed)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if !vm.liveMatches.isEmpty {
                                sectionHeader("🔴  LIVE NOW")
                                ForEach(vm.liveMatches) { match in
                                    NavigationLink(destination: MatchView(vm: MatchViewModel(match: match))) {
                                        MatchCardView(match: match)
                                            .padding(.horizontal, 16)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }

                            if !vm.otherMatches.isEmpty {
                                sectionHeader("📋  MATCHES")
                                ForEach(vm.otherMatches) { match in
                                    NavigationLink(destination: MatchView(vm: MatchViewModel(match: match))) {
                                        MatchCardView(match: match)
                                            .padding(.horizontal, 16)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                    }
                    .refreshable { vm.load() }
                }
            }
            .navigationTitle("HATER OF THE MATCH")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color.haterBackground, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private func sectionHeader(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 12, weight: .black))
                .foregroundStyle(Color.gray)
                .padding(.horizontal, 20)
            Spacer()
        }
        .padding(.top, 8)
    }
}
