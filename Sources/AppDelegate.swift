import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timerManager = TimerManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            // Use a tomato emoji for better Pomodoro branding
            button.title = "🍅"
            button.action = #selector(toggleWindow)
            button.target = self
        }
        
        // Build menu
        let menu = NSMenu()
        
        let showItem = NSMenuItem(title: "Show timer", action: #selector(showWindow), keyEquivalent: "")
        showItem.target = self
        menu.addItem(showItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
        
        // Hide dock icon initially
        NSApp.setActivationPolicy(.accessory)
    }
    
    @MainActor @objc func toggleWindow() {
        if let window = NSApp.windows.first {
            if window.isVisible {
                window.orderOut(nil)
            } else {
                showWindow()
            }
        }
    }
    
    @MainActor @objc func showWindow() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.windows.first?.makeKeyAndOrderFront(nil)
    }
    
    @MainActor @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
