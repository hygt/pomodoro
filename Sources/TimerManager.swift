import SwiftUI
import Foundation
import AppKit

@MainActor
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
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if self.currentTime > 0 {
                    self.currentTime -= 1
                    self.updateMenuBarIcon()
                } else {
                    self.completeSession()
                }
            }
        }
        
        // Hide window and show in menu bar
        NSApp.windows.first?.orderOut(nil)
        NSApp.setActivationPolicy(.accessory)
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
        if let statusItem = (NSApp.delegate as? AppDelegate)?.statusItem {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            statusItem.button?.title = String(format: "%02d:%02d", minutes, seconds)
            statusItem.button?.imagePosition = .imageLeft
            
            // Keep the app icon alongside the timer
            if statusItem.button?.image == nil {
                if let appIcon = NSApp.applicationIconImage {
                    let scaledIcon = NSImage(size: NSSize(width: 18, height: 18))
                    scaledIcon.lockFocus()
                    appIcon.draw(in: NSRect(x: 0, y: 0, width: 18, height: 18))
                    scaledIcon.unlockFocus()
                    statusItem.button?.image = scaledIcon
                }
            }
        }
    }
    
    private func showAlarm() {
        // Show window and bring to front
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
        
        // Play system sound
        NSSound.beep()
    }
}
