import SwiftUI

@main
struct PomodoroApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appDelegate.timerManager)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
