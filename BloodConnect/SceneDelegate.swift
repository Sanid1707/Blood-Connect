//
//  SceneDelegate.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import UIKit
import SwiftUI
import SwiftData
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var syncService: FirebaseDataService?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        do {
            // Initialize DatabaseManager to ensure schema and migrations are set up
            let container = DatabaseManager.shared.modelContainer
            
            // Create the SwiftUI view that provides the window contents - Now using SplashView
            let contentView = SplashView()
                .modelContainer(container)
                .environmentObject(createAuthViewModel())

            // Use a UIHostingController as window root view controller
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: contentView)
                self.window = window
                window.makeKeyAndVisible()
            }
            
            // Initialize the sync service
            self.syncService = FirebaseDataService(modelContext: container.mainContext)
            
            // Sync data with Firebase
            syncDataWithFirebase()
            
        } catch {
            fatalError("Failed to create model container: \(error)")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        // Sync data when the app becomes active
        syncDataWithFirebase()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Push any pending changes to Firebase before entering background
        syncDataWithFirebase()
    }
    
    // MARK: - Private Methods
    
    private func createAuthViewModel() -> AuthViewModel {
        // Create an instance of your custom auth view model
        // Use FirebaseAuthService instead of regular AuthService
        let authViewModel = AuthViewModel()
        
        // Check if currently authenticated
        if FirebaseAuthService().isAuthenticated() {
            authViewModel.authenticate()
        }
        
        return authViewModel
    }
    
    private func syncDataWithFirebase() {
        // Check network connectivity first
        // For now, just attempt sync
        Task {
            do {
                try await syncService?.syncAll()
            } catch {
                print("Error syncing data with Firebase: \(error.localizedDescription)")
            }
        }
    }
}

