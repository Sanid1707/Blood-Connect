//
//  AppDelegate.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import UIKit
import SwiftData
import FirebaseCore
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    private let notificationManager = NotificationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Set up notifications
        setupNotifications(application)
        
        // Initialize services on the main thread since we're accessing @MainActor-isolated types
        Task { @MainActor in
            setupServices()
            
            // Create sample data
            if UserDefaultsService.shared.isFirstLaunch {
                try? await createSampleData()
                UserDefaultsService.shared.isFirstLaunch = false
            }
        }
        
        // Update last open date in UserDefaults
        UserDefaultsService.shared.lastOpenDate = Date()
        
        // Print database location for debugging
        printDatabaseLocation()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Private Methods
    
    @MainActor
    private func setupServices() {
        // Initialize database and provide visual feedback if there was recovery
        print("Initializing BloodConnect database...")
        let databaseManager = DatabaseManager.shared
        
        // Log the database path
        printDatabaseLocation()
        
        // Prepare database (migrations, etc.)
        databaseManager.prepareDatabase()
        
        // Log successful initialization
        print("BloodConnect services initialized successfully")
    }
    
    @MainActor
    private func createSampleData() async throws {
        let sampleDataService = SampleDataService()
        try await sampleDataService.createSampleData()
    }
    
    private func printDatabaseLocation() {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let appSupportURL = urls.first {
            let dbFolderURL = appSupportURL.appendingPathComponent("default.store")
            print("SwiftData database location: \(dbFolderURL.path)")
        }
    }
    
    // Setup notifications
    private func setupNotifications(_ application: UIApplication) {
        // Set notification delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Request authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
        
        // Set up notification categories and actions
        notificationManager.setupNotificationActions()
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification response
        let userInfo = response.notification.request.content.userInfo
        
        if let requestId = userInfo["requestId"] as? String {
            print("User responded to blood request notification: \(requestId)")
            // Here you would typically navigate to the appropriate screen
            // This would be handled by the SceneDelegate in a real app
        }
        
        completionHandler()
    }
}

