//
//  RemindersManager.swift
//  linearem
//
//  Created by Nick Pio on 2025-07-07.
//

import Foundation
import EventKit

class RemindersManager: ObservableObject {
    static let shared = RemindersManager()
    private let eventStore = EKEventStore()
    
    @Published var reminders: [EKReminder] = []
    @Published var accessGranted: Bool = false
    
    private init() { }
    
    func requestAccess(completion: @escaping (Bool) -> Void) {
        eventStore.requestFullAccessToReminders() { granted, error in
            DispatchQueue.main.async {
                self.accessGranted = granted
                completion(granted)
            }
        }
    }
    
    func fetchReminders(completion: @escaping ([EKReminder]) -> Void) {
        let predicate = eventStore.predicateForReminders(in: nil)
        eventStore.fetchReminders(matching: predicate) { reminders in
            DispatchQueue.main.async {
                self.reminders = reminders ?? []
                completion(self.reminders)
            }
        }
    }
    
    func addReminder(title: String, notes: String? = nil, dueDate: Date? = nil, completion: ((EKReminder?) -> Void)? = nil) {
        guard accessGranted else {
            completion?(nil)
            return
        }
        
        let reminder = EKReminder(eventStore: eventStore)
        reminder.title = title
        reminder.notes = notes
        if let dueDate = dueDate {
            reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        }
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        do {
            try eventStore.save(reminder, commit: true)
            fetchReminders { _ in
                completion?(reminder)
            }
        } catch {
            print("Failed to save reminder: \(error)")
            completion?(nil)
        }
    }
    
    
}
