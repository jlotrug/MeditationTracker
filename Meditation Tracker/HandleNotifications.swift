//
//  HandleNotifications.swift
//  Meditation Tracker
//
//  Created by Jim Lotruglio on 8/10/23.
//

import Foundation
import UserNotifications

// Takes date user selects and schedules repeating notifications for that time each day
func scheduleNotifications(selectedDate: Date){
    // Cancels any previous notifications
    cancelPreviousNotifications()
    
    let content = UNMutableNotificationContent()
    content.title = "We miss you"
    content.subtitle = "Don't forget to meditate today!"
    content.sound = UNNotificationSound.default

    let date = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

//     For demonstration only
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}

// Request permission from user the first time the app is loaded
func requestPermission(){
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){
        success, error in
        if success{
            print("Notifications have been enabled")
        } else if let error = error{
            print(error.localizedDescription)
        }
    }
}

// Cancel previous notifications
func cancelPreviousNotifications(){
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
}
