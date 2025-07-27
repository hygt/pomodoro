import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 20) {
                Text(timerManager.isFocusSession ? "🍅 Focus Time" : "☕ Break Time")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(timerManager.isFocusSession ? .red : .green)
                
                Text(timeString(from: timerManager.currentTime))
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 20) {
                Button(action: {
                    if timerManager.isRunning {
                        timerManager.pauseTimer()
                    } else {
                        timerManager.startTimer()
                    }
                }) {
                    HStack {
                        Image(systemName: timerManager.isRunning ? "pause.fill" : "play.fill")
                        Text(timerManager.isRunning ? "Pause" : "Resume")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(timerManager.isRunning ? Color.orange : Color.green)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: timerManager.resetTimer) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise")
                        Text("Reset")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: timerManager.showConfiguration) {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Configure")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            ProgressView(value: progressValue)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(height: 8)
                .scaleEffect(x: 1, y: 2)
        }
        .padding(40)
        .frame(minWidth: 400, minHeight: 400)
        .background(Color(.controlBackgroundColor))
    }
    
    private var progressValue: Double {
        // This is a simplified progress calculation
        // In a real implementation, you'd track the total time for accurate progress
        return timerManager.currentTime > 0 ? 0.5 : 1.0
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
