import SwiftUI

struct RageTabView: View {
    @Bindable var vm: MatchViewModel

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                RageOMeterView(rageLevel: vm.rageLevel, pulse: vm.ragePulse)

                Text("TAP TO RAGE")
                    .font(.system(size: 11, weight: .black))
                    .foregroundStyle(Color.gray)
                    .tracking(3)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(QuickRageType.allCases) { type in
                        RageButton(type: type) {
                            vm.quickRage(type: type)
                        }
                    }
                }
                .padding(.horizontal, 16)

                // Top hated player teaser
                if let top = vm.sortedByHate.first {
                    VStack(spacing: 6) {
                        Text("CURRENT VILLAIN")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(Color.gray)
                            .tracking(2)
                        HStack(spacing: 10) {
                            Text("💀")
                                .font(.system(size: 28))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(top.name)
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundStyle(Color.white)
                                Text("\(top.totalHate) hate points")
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.haterRed)
                            }
                            Spacer()
                            Text("#\(top.number)")
                                .font(.system(size: 22, weight: .black))
                                .foregroundStyle(Color.gray)
                        }
                        .padding(14)
                        .background(Color.haterCard)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.haterRed.opacity(0.4), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal, 16)
                }

                Spacer(minLength: 32)
            }
            .padding(.top, 16)
        }
    }
}

extension QuickRageType: CaseIterable, Identifiable {
    static var allCases: [QuickRageType] { [.boo, .redCard, .dive, .offside] }
    var id: String { label }
}
