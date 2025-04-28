import Foundation
import SwiftData
import Combine
import CoreLocation

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
    
    // Get all donors (used for blood request notifications)
    func getDonors() -> [User] {
        return getUsersByType(type: "donor")
    }
    
    // Get donors by blood type
    func getDonorsByBloodType(bloodType: String) -> [User] {
        do {
            let descriptor = FetchDescriptor<UserModel>(sortBy: [SortDescriptor(\.name)])
            let allUserModels = try modelContext.fetch(descriptor)
            
            // Filter manually to find donors with compatible blood type
            let donorModels = allUserModels.filter { userModel in
                userModel.userType.caseInsensitiveCompare("donor") == .orderedSame &&
                userModel.bloodType == bloodType
            }
            
            return donorModels.map { $0.toUser() }
        } catch {
            print("Error fetching donors by blood type: \(error.localizedDescription)")
            return []
        }
    }
    
    // Get compatible donors for a specific blood type
    func getCompatibleDonors(forBloodType requestedBloodType: String) -> [User] {
        do {
            let descriptor = FetchDescriptor<UserModel>(sortBy: [SortDescriptor(\.name)])
            let allUserModels = try modelContext.fetch(descriptor)
            
            // Filter manually to find donors with compatible blood type
            let donorModels = allUserModels.filter { userModel in
                userModel.userType.caseInsensitiveCompare("donor") == .orderedSame &&
                isBloodCompatible(requestBloodType: requestedBloodType, donorBloodType: userModel.bloodType ?? "")
            }
            
            return donorModels.map { $0.toUser() }
        } catch {
            print("Error fetching compatible donors: \(error.localizedDescription)")
            return []
        }
    }
    
    // Check if donor blood type is compatible with requested blood type
    func isBloodCompatible(requestBloodType: String, donorBloodType: String) -> Bool {
        // Blood compatibility rules
        // O- can donate to anyone
        if donorBloodType == "O-" {
            return true
        }
        
        // AB+ can receive from anyone
        if requestBloodType == "AB+" {
            return true
        }
        
        // Same blood type is always compatible
        if requestBloodType == donorBloodType {
            return true
        }
        
        // O+ can donate to A+, B+, AB+
        if donorBloodType == "O+" {
            return ["A+", "B+", "AB+"].contains(requestBloodType)
        }
        
        // A- can donate to A+, A-, AB+, AB-
        if donorBloodType == "A-" {
            return ["A+", "A-", "AB+", "AB-"].contains(requestBloodType)
        }
        
        // A+ can donate to A+, AB+
        if donorBloodType == "A+" {
            return ["A+", "AB+"].contains(requestBloodType)
        }
        
        // B- can donate to B+, B-, AB+, AB-
        if donorBloodType == "B-" {
            return ["B+", "B-", "AB+", "AB-"].contains(requestBloodType)
        }
        
        // B+ can donate to B+, AB+
        if donorBloodType == "B+" {
            return ["B+", "AB+"].contains(requestBloodType)
        }
        
        // AB- can donate to AB+, AB-
        if donorBloodType == "AB-" {
            return ["AB+", "AB-"].contains(requestBloodType)
        }
        
        // Default to false for safety
        return false
    }
    
    // Get donors within a certain radius of a location
    func getDonorsWithinRadius(latitude: Double, longitude: Double, radiusInKm: Double) -> [User] {
        // Get all donors
        let donors = getDonors()
        
        // Filter donors with location data
        let donorsWithLocation = donors.filter { donor in
            return donor.latitude != nil && donor.longitude != nil
        }
        
        // Calculate distance for each donor and filter based on radius
        let requestLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        let donorsInRadius = donorsWithLocation.filter { donor in
            guard let donorLat = donor.latitude, let donorLng = donor.longitude else {
                return false
            }
            
            let donorLocation = CLLocation(latitude: donorLat, longitude: donorLng)
            let distanceInMeters = donorLocation.distance(from: requestLocation)
            let distanceInKilometers = distanceInMeters / 1000.0
            
            return distanceInKilometers <= radiusInKm
        }
        
        return donorsInRadius
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
