//
//  AppDelegate.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import UIKit
import SwiftData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize services on the main thread since we're accessing @MainActor-isolated types
        Task { @MainActor in
            setupServices()
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
        // Initialize database
        _ = DatabaseManager.shared
        DatabaseManager.shared.prepareDatabase()
        
        // Log successful initialization
        print("BloodConnect services initialized successfully")
    }
    
    private func printDatabaseLocation() {
        // Print the application support directory path where SwiftData stores databases
        let appSupportPath = URL.applicationSupportDirectory.path(percentEncoded: false)
        let dbPath = "\(appSupportPath)/default.store"
        print("--------------------------------")
        print("📊 DATABASE LOCATION:")
        print("📂 \(dbPath)")
        print("--------------------------------")
        
        // Also print the documents directory for convenience
        if let docsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path {
            print("📁 Documents directory: \(docsPath)")
        }
        
        // Print command to open the folder
        print("To open in Finder, run this in Terminal:")
        print("open \"\(appSupportPath)\"")
        print("--------------------------------")
    }
}

