import SwiftUI
import Foundation
import AppKit

class TimerManager: ObservableObject {
    @Published var isRunning = false
    @Published var currentTime: TimeInterval = 0
    @Published var isFocusSession = true
    @Published var isConfiguring = true
    
    private var timer: Timer?
    private var focusTime: TimeInterval = 25 * 60
    private var breakTime: TimeInterval = 5 * 60
    
    func configure(focusTime: TimeInterval, breakTime: TimeInterval) {
        self.focusTime = focusTime
        self.breakTime = breakTime
        self.currentTime = focusTime
        self.isFocusSession = true
    }
    
    func startTimer() {
        isRunning = true
        isConfiguring = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.currentTime > 0 {
                self.currentTime -= 1
                self.updateMenuBarIcon()
            } else {
                self.completeSession()
            }
        }
        
        // Hide window and show in menu bar
        DispatchQueue.main.async {
            NSApp.windows.first?.orderOut(nil)
            NSApp.setActivationPolicy(.accessory)
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        currentTime = isFocusSession ? focusTime : breakTime
        updateMenuBarIcon()
    }
    
    func showConfiguration() {
        isConfiguring = true
        pauseTimer()
    }
    
    private func completeSession() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        
        // Switch session type
        isFocusSession.toggle()
        currentTime = isFocusSession ? focusTime : breakTime
        
        // Show visual alarm
        showAlarm()
        
        // Auto-start the next session (especially for breaks)
        startTimer()
    }
    
    private func updateMenuBarIcon() {
        let time = currentTime
        DispatchQueue.main.async {
            if let statusItem = (NSApp.delegate as? AppDelegate)?.statusItem {
                let minutes = Int(time) / 60
                let seconds = Int(time) % 60
                statusItem.button?.title = String(format: "%02d:%02d", minutes, seconds)
            }
        }
    }
    
    private func showAlarm() {
        // Show window and bring to front
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            
            if let window = NSApp.windows.first {
                window.makeKeyAndOrderFront(nil)
                window.level = .floating
                
                // Simple flash by changing opacity quickly
                for i in 0..<6 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                        window.alphaValue = i % 2 == 0 ? 0.5 : 1.0
                    }
                }
                
                // Restore normal level after flashing
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    window.level = .normal
                    window.alphaValue = 1.0
                }
            }
        }
        
        // Play system sound
        NSSound.beep()
    }
}
