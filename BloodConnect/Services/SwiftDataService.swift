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
    
    // Create a new user
    func createUser(_ user: User) async throws -> User {
        // Check if a user with this ID already exists to avoid duplicates
        if let existingId = user.id, !existingId.isEmpty {
            // Search for existing user
            let predicate = #Predicate<UserModel> { $0.id == existingId }
            let descriptor = FetchDescriptor<UserModel>(predicate: predicate)
            
            if let existingUser = try? modelContext.fetch(descriptor).first {
                print("User with ID \(existingId) already exists, updating instead")
                // Update the existing user with new data
                if let bloodType = user.bloodType?.rawValue {
                    existingUser.bloodType = bloodType
                }
                existingUser.name = user.name
                existingUser.email = user.email
                existingUser.phoneNumber = user.phoneNumber
                existingUser.donationCount = user.donationCount
                existingUser.county = user.county
                existingUser.userType = user.userType
                existingUser.availability = user.availability
                existingUser.address = user.address
                existingUser.latitude = user.latitude
                existingUser.longitude = user.longitude
                existingUser.organizationDescription = user.organizationDescription
                existingUser.workingHours = user.workingHours
                existingUser.eircode = user.eircode
                existingUser.lastDonationDate = user.lastDonationDate
                
                try modelContext.save()
                return existingUser.toUser()
            }
        }
        
        // Create a new user model
        let userModel = UserModel(from: user)
        modelContext.insert(userModel)
        try modelContext.save()
        
        print("Created new user: \(userModel.name)")
        return userModel.toUser()
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
