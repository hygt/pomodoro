# Pomodoro timer Swift application

Simple Pomodoro timer using SwiftUI.
Opens a configuration dialog box and minimize a background application in the macOS menu bar.

## Commands
- Build: `swift build`
- Run: `swift run`
- Test: `swift test`
- Clean: `swift package clean`

## Architecture
- Simple Swift executable package using Swift Package Manager
- Single executable target named "pomodoro"
- Entry point: `Sources/PomodoroApp.swift`
- Swift 6.1+ required (specified in Package.swift)
- Target macOS 14 Sonoma or more recent

## Code Style
- Use Swift standard conventions and naming (camelCase for variables/functions, PascalCase for types)
- No external dependencies currently - keep it simple
- Follow Swift API Design Guidelines
- Use proper error handling with Result types or throwing functions when needed
- Prefer explicit types when clarity is important
- Use Swift's built-in formatting and linting via Xcode/VS Code extensions
