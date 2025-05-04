import Foundation
import UserNotifications

class NotificationManager {
    let notificationCenter = UNUserNotificationCenter.current()
    
    init() {
        // Request authorization for notifications
        requestAuthorization()
    }
    
    // Request permission for notifications
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    // Schedule a local notification
    func scheduleNotification(identifier: String, content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully with ID: \(identifier)")
            }
        }
    }
    
    // Cancel a specific notification
    func cancelNotification(identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Cancel all pending notifications
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    // Create notification for blood request
    func createBloodRequestNotification(requestId: String, bloodGroup: String, patientName: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Blood Request"
        content.body = "Patient \(patientName) needs \(bloodGroup) blood."
        content.sound = .default
        content.userInfo = ["requestId": requestId]
        content.categoryIdentifier = "bloodRequest"
        
        return content
    }
    
    // Create urgent blood request notification
    func createUrgentBloodRequestNotification(requestId: String, bloodGroup: String, patientName: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "URGENT: Blood Request"
        content.body = "Patient \(patientName) urgently needs \(bloodGroup) blood. Please respond immediately!"
        content.sound = .default
        content.userInfo = ["requestId": requestId, "urgent": true]
        content.categoryIdentifier = "urgentBloodRequest"
        
        return content
    }
    
    // Setup notification actions
    func setupNotificationActions() {
        // Regular blood request actions
        let respondAction = UNNotificationAction(
            identifier: "RESPOND_ACTION",
            title: "Respond",
            options: .foreground
        )
        
        let ignoreAction = UNNotificationAction(
            identifier: "IGNORE_ACTION",
            title: "Ignore",
            options: .destructive
        )
        
        let bloodRequestCategory = UNNotificationCategory(
            identifier: "bloodRequest",
            actions: [respondAction, ignoreAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Urgent blood request actions
        let urgentRespondAction = UNNotificationAction(
            identifier: "URGENT_RESPOND_ACTION",
            title: "Respond Urgently",
            options: .foreground
        )
        
        let urgentBloodRequestCategory = UNNotificationCategory(
            identifier: "urgentBloodRequest",
            actions: [urgentRespondAction, ignoreAction],
            intentIdentifiers: [],
            options: []
        )
        
        // Register the categories
        notificationCenter.setNotificationCategories([bloodRequestCategory, urgentBloodRequestCategory])
    }
} 