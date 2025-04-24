//
//  AppDelegate.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import UIKit
import SwiftData
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
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
        // Initialize database
        _ = DatabaseManager.shared
        DatabaseManager.shared.prepareDatabase()
        
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
}

