import Foundation
import SwiftData
import Combine

@MainActor
class UserService {
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext ?? DatabaseManager.shared.mainContext
    }
    
    // Get all users
    func getAllUsers() -> [User] {
        do {
            let descriptor = FetchDescriptor<UserModel>()
            let userModels = try modelContext.fetch(descriptor)
            return userModels.map { $0.toUser() }
        } catch {
            print("Error fetching users: \(error.localizedDescription)")
            return []
        }
    }
    
    // Get users by type (donor or organization)
    func getUsersByType(type: String) -> [User] {
        do {
            // Case-insensitive comparison is done manually after fetch
            let descriptor = FetchDescriptor<UserModel>(sortBy: [SortDescriptor(\.name)])
            let allUserModels = try modelContext.fetch(descriptor)
            
            // Filter manually to perform case-insensitive comparison
            let userModels = allUserModels.filter { userModel in
                userModel.userType.caseInsensitiveCompare(type) == .orderedSame
            }
            
            print("Found \(userModels.count) users with type: \(type)")
            return userModels.map { $0.toUser() }
        } catch {
            print("Error fetching users by type: \(error.localizedDescription)")
            return []
        }
    }
    
    // Get individual users (not organizations)
    func getIndividualDonors() -> [User] {
        return getUsersByType(type: "donor")
    }
    
    // Get organization users
    func getOrganizations() -> [User] {
        return getUsersByType(type: "organization")
    }
    
    // Synchronize with Firebase (wrapper around FirebaseDataService)
    func syncWithFirebase() async {
        do {
            let firebaseService = FirebaseDataService(modelContext: modelContext)
            try await firebaseService.syncAll()
            print("Successfully synced with Firebase")
        } catch {
            print("Error syncing with Firebase: \(error.localizedDescription)")
        }
    }
} 
