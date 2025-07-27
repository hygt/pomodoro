import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    @State private var focusTime: TimeInterval = 25 * 60
    @State private var breakTime: TimeInterval = 5 * 60
    
    var body: some View {
        if timerManager.isConfiguring {
            ConfigurationView(
                focusTime: $focusTime,
                breakTime: $breakTime,
                onStart: {
                    timerManager.configure(focusTime: focusTime, breakTime: breakTime)
                    timerManager.startTimer()
                }
            )
        } else {
            TimerView()
        }
    }
}
