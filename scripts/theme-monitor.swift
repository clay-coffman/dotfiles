#!/usr/bin/swift
// Theme monitor for macOS appearance changes
// Monitors system appearance and triggers theme switching

import Foundation
import Cocoa

class ThemeMonitor {
    let scriptPath = "\(NSHomeDirectory())/.dotfiles/scripts/theme-switcher.sh"
    var lastAppearance: NSAppearance.Name?
    
    init() {
        // Get initial appearance
        lastAppearance = NSApp.effectiveAppearance.name
        
        // Start monitoring
        startMonitoring()
    }
    
    func startMonitoring() {
        // Monitor appearance changes
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(appearanceChanged),
            name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
        
        // Also monitor effective appearance changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(effectiveAppearanceChanged),
            name: NSNotification.Name("NSAppearanceDidChangeNotification"),
            object: nil
        )
        
        print("Theme monitor started. Monitoring for appearance changes...")
    }
    
    @objc func appearanceChanged(_ notification: Notification) {
        runThemeSwitcher()
    }
    
    @objc func effectiveAppearanceChanged(_ notification: Notification) {
        let currentAppearance = NSApp.effectiveAppearance.name
        if currentAppearance != lastAppearance {
            lastAppearance = currentAppearance
            runThemeSwitcher()
        }
    }
    
    func runThemeSwitcher() {
        print("Appearance changed, running theme switcher...")
        
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [scriptPath, "--force"]
        
        do {
            try task.run()
            task.waitUntilExit()
            
            if task.terminationStatus == 0 {
                print("Theme switcher completed successfully")
            } else {
                print("Theme switcher failed with status: \(task.terminationStatus)")
            }
        } catch {
            print("Error running theme switcher: \(error)")
        }
    }
}

// Create app and run
let app = NSApplication.shared
let monitor = ThemeMonitor()

// Keep the app running
RunLoop.current.run()