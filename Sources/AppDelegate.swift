import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timerManager: TimerManager!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Initialize the timer manager on the main actor
        timerManager = TimerManager()
        
        // Set the application icon
        setApplicationIcon()
        
        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            // Use the app icon for the status bar
            if let appIcon = loadAppIcon(size: 16) {
                button.image = appIcon
                button.imagePosition = .imageOnly
            } else {
                // Fallback to tomato emoji if app icon isn't available
                button.title = "🍅"
            }
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
    
    // MARK: - Icon Helper Methods
    
    @MainActor private func setApplicationIcon() {
        // Load the 512x512 app icon for the main application
        if let appIcon = loadAppIcon(size: 512) {
            NSApp.applicationIconImage = appIcon
        }
    }
    
    private func loadAppIcon(size: Int) -> NSImage? {
        // First try to load from AppIcon asset catalog
        if let appIcon = NSImage(named: "AppIcon") {
            let scaledIcon = NSImage(size: NSSize(width: size, height: size))
            scaledIcon.lockFocus()
            appIcon.draw(in: NSRect(x: 0, y: 0, width: size, height: size))
            scaledIcon.unlockFocus()
            return scaledIcon
        }
        
        // Fallback: Try to load the specific size from the AppIcons bundle
        guard let iconURL = Bundle.main.url(forResource: "\(size)", withExtension: "png", subdirectory: "AppIcons/Assets.xcassets/AppIcon.appiconset") else {
            print("Could not find icon file: \(size).png")
            return nil
        }
        
        return NSImage(contentsOf: iconURL)
    }
}
