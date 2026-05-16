# 💀 HaterOfTheMatch

> The dark mirror of [FanOfTheMatch](https://www.fanofthematch.ai/) — built as a concept project for a Pluggable.ai interview.

Instead of celebrating the best player on the pitch, **HaterOfTheMatch** lets fans vent. Vote for the Villain of the Match, rage-rate every player, and watch the collective Rage-O-Meter climb in real time.

---

## Concept

|                   | FanOfTheMatch            | HaterOfTheMatch                 |
| ----------------- | ------------------------ | ------------------------------- |
| **Core vote**     | Man of the Match         | 💀 Villain of the Match         |
| **Player rating** | Celebrate top performers | Rage-rate 1–10                  |
| **Crowd metric**  | Engagement level         | 🔥 Rage-O-Meter                 |
| **Quick actions** | Cheer, applaud           | BOO / RED CARD / DIVE / OFFSIDE |
| **Theme**         | Bright, fan joy          | Dark, anger                     |

FanOfTheMatch is web-first with no friction — scan a QR code and you're in. HaterOfTheMatch takes the opposite design bet: a native iOS app for richer, persistent engagement beyond the stadium.

---

## Features

- **Rage-O-Meter** — animated arc gauge showing collective fan rage across all votes
- **Villain of the Match** — single-vote system with live percentage bars per player
- **Player Rating** — per-player rage slider (1–10) with anger emoji feedback
- **Quick Rage** — one-tap BOO, RED CARD, DIVE, and OFFSIDE buttons
- **Live match cards** — pulsing indicator, rage bar, and score on the home screen
- **Pull to refresh** — simulated match data reload

---

## Tech

- **Swift / SwiftUI** — 100% SwiftUI, no UIKit
- **iOS 17+** — uses `@Observable` macro, no `ObservableObject`
- **MVVM** — `HomeViewModel` + `MatchViewModel` with `@MainActor` isolation
- **Zero dependencies** — no external packages, no CocoaPods
- **XcodeGen** — project generated from `project.yml`, no bloated `.pbxproj` diffs

---

## Structure

```
HaterOfTheMatch/
├── Models/
│   ├── Match.swift          # Match, Team, MatchStatus
│   ├── Player.swift         # Player, Position
│   └── MockData.swift       # Sample matches & players
├── ViewModels/
│   ├── HomeViewModel.swift
│   └── MatchViewModel.swift # Voting, rating, rage logic
└── Views/
    ├── Home/                # HomeView, MatchCardView
    ├── Match/               # MatchView, RageOMeterView, RageTabView
    ├── Voting/              # VillainVoteView, PlayerRatingView
    └── Components/          # RageButton, LivePulseDot, HaterColors
```

---

## Running

Requires Xcode 16+ and iOS 17 Simulator.

```bash
# If you want to regenerate the Xcode project
brew install xcodegen
xcodegen generate

# Open and run
open HaterOfTheMatch.xcodeproj
```

Hit `⌘R` in Xcode to launch on simulator.

---

## About

Built for an interview concept project for [Pluggable.ai](https://www.pluggable.ai), the team behind FanOfTheMatch — a real-time fan engagement platform used by UEFA, Manchester City, FC Barcelona, and SC Braga.
