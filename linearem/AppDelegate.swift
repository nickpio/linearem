//
//  AppDelegate.swift
//  linearem
//
//  Created by Nick Pio on 2025-07-07.
//

import Cocoa
import EventKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    let eventStore = EKEventStore()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
    
    }
    
    func requestRemindersAccess() {
        eventStore.requestFullAccessToReminders() { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Reminders access granted.")
                    // Initialize reminders manager
                } else {
                    print("Reminders access denied: \(error?.localizedDescription ?? "Unknown Error")")
                    self.showRemindersAccessAlert()
                }
            }
        }
    }
    
    func showRemindersAccessAlert() {
        let alert = NSAlert()
        alert.messageText = "Reminders access needed"
        alert.informativeText = """
            This app requires access to Apple Reminders to sync with Linear.
            Please grant permission in System Settings.
            """
        alert.alertStyle = .warning
        alert.runModal()
    }
    
    
}
