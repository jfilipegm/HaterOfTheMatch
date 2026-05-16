import SwiftUI

struct CreateEventSheet: View {
    @Environment(EventManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    @State private var code = ""
    @State private var matchName = ""
    @State private var competition = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.haterBackground.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        field(label: "EVENT ID", placeholder: "Leave blank to auto-generate", text: $code)
                            .textInputAutocapitalization(.characters)

                        field(label: "MATCH", placeholder: "e.g. Man City vs Chelsea", text: $matchName)

                        field(label: "COMPETITION", placeholder: "e.g. Champions League", text: $competition)

                        Button {
                            manager.create(
                                code: code,
                                matchName: matchName.isEmpty ? "Untitled Match" : matchName,
                                competition: competition.isEmpty ? "—" : competition
                            )
                            dismiss()
                        } label: {
                            Text("CREATE EVENT")
                                .font(.system(size: 15, weight: .black))
                                .tracking(2)
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.haterRed)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.top, 8)
                    }
                    .padding(24)
                }
            }
            .navigationTitle("NEW EVENT")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.haterBackground, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.gray)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func field(label: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(Color.gray)
                .tracking(2)
            TextField("", text: text, prompt: Text(placeholder).foregroundStyle(Color.gray.opacity(0.35)))
                .font(.system(size: 16))
                .foregroundStyle(Color.white)
                .padding(14)
                .background(Color.haterCard)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
                .autocorrectionDisabled()
        }
    }
}
