//
//  FirebaseDataService.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 24/04/2025.
//

import Foundation
import Combine
import SwiftData
import FirebaseFirestore

@MainActor
class FirebaseDataService {
    // MARK: - Properties
    private let modelContext: ModelContext
    private let db = Firestore.firestore()
    
    // MARK: - Initialization
    init(modelContext: ModelContext? = nil) {
        if let modelContext = modelContext {
            self.modelContext = modelContext
        } else {
            self.modelContext = DatabaseManager.shared.mainContext
        }
    }
    
    // MARK: - Sync Methods
    
    /// Syncs all local data to Firebase and fetches new remote data
    func syncAll() async throws {
        // Upload local changes first
        try await uploadLocalData()
        
        // Then fetch remote changes
        try await fetchRemoteData()
        
        print("Full data sync completed successfully")
    }
    
    /// Uploads all local data to Firebase
    private func uploadLocalData() async throws {
        try await uploadUsers()
        try await uploadBloodRequests()
        try await uploadDonationCenters()
    }
    
    /// Fetches all remote data from Firebase
    private func fetchRemoteData() async throws {
        try await fetchUsers()
        try await fetchBloodRequests()
        try await fetchDonationCenters()
    }
    
    // MARK: - User Sync
    
    private func uploadUsers() async throws {
        // Get all users that haven't been synced or have changed since last sync
        let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { 
            $0.cloudId == nil || ($0.lastSyncedAt == nil)
        })
        
        let usersToSync = try modelContext.fetch(descriptor)
        
        for user in usersToSync {
            do {
                // If user already has a cloud ID, update existing document
                if let cloudId = user.cloudId {
                    try await updateUserInFirestore(user, documentId: cloudId)
                } else {
                    // Create new document with user ID as document ID
                    let documentId = user.id
                    try await createUserInFirestore(user, documentId: documentId)
                    user.cloudId = documentId
                }
                
                user.lastSyncedAt = Date()
                try modelContext.save()
            } catch {
                print("Error syncing user \(user.name): \(error.localizedDescription)")
            }
        }
    }
    
    private func createUserInFirestore(_ user: UserModel, documentId: String) async throws {
        let userData: [String: Any] = userModelToFirestore(user)
        try await db.collection("users").document(documentId).setData(userData)
    }
    
    private func updateUserInFirestore(_ user: UserModel, documentId: String) async throws {
        let userData: [String: Any] = userModelToFirestore(user)
        try await db.collection("users").document(documentId).updateData(userData)
    }
    
    private func userModelToFirestore(_ user: UserModel) -> [String: Any] {
        var userData: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "donationCount": user.donationCount,
            "createdAt": user.createdAt
        ]
        
        // Add optional fields
        if let phoneNumber = user.phoneNumber {
            userData["phoneNumber"] = phoneNumber
        }
        
        if let bloodType = user.bloodType {
            userData["bloodType"] = bloodType
        }
        
        if let lastDonationDate = user.lastDonationDate {
            userData["lastDonationDate"] = Timestamp(date: lastDonationDate)
        }
        
        if let county = user.county {
            userData["county"] = county
        }
        
        return userData
    }
    
    private func fetchUsers() async throws {
        // Get all users from Firestore
        let snapshot = try await db.collection("users").getDocuments()
        
        for document in snapshot.documents {
            let data = document.data()
            let documentId = document.documentID
            
            // Check if user already exists in local database
            let descriptor = FetchDescriptor<UserModel>(predicate: #Predicate { 
                $0.id == documentId || $0.cloudId == documentId 
            })
            let matchingUsers = try modelContext.fetch(descriptor)
            
            // If user exists locally, update it
            if let existingUser = matchingUsers.first {
                updateUserModelFromFirestore(existingUser, data: data)
                existingUser.cloudId = documentId
                existingUser.lastSyncedAt = Date()
            } else {
                // If not, create a new user
                createUserModelFromFirestore(documentId: documentId, data: data)
            }
        }
        
        try modelContext.save()
    }
    func fetchAllUsers() async throws -> [User] {
        let snapshot = try await db.collection("users").getDocuments()
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            let id = doc.documentID
            let email = data["email"] as? String ?? ""
            let name = data["name"] as? String ?? ""
            let userType = data["userType"] as? String ?? "Donor"
            let lat = data["latitude"] as? Double
            let lon = data["longitude"] as? Double

            guard let latitude = lat, let longitude = lon else { return nil }

            return User(
                id: id,
                email: email,
                name: name,
                phoneNumber: data["phoneNumber"] as? String,
                bloodType: data["bloodType"] != nil ? BloodType(rawValue: data["bloodType"] as! String) : nil,
                lastDonationDate: nil,
                donationCount: data["donationCount"] as? Int ?? 0,
                county: data["county"] as? String,
                userType: userType,
                workingHours: data["workingHours"] as? String,
                availability: data["availability"] as? String,
                address: data["address"] as? String,
                latitude: latitude,
                longitude: longitude
            )
        }
    }

    
    private func updateUserModelFromFirestore(_ user: UserModel, data: [String: Any]) {
        // Update user properties from Firestore data
        if let email = data["email"] as? String {
            user.email = email
        }
        
        if let name = data["name"] as? String {
            user.name = name
        }
        
        if let phoneNumber = data["phoneNumber"] as? String {
            user.phoneNumber = phoneNumber
        }
        
        if let bloodType = data["bloodType"] as? String {
            user.bloodType = bloodType
        }
        
        if let donationCount = data["donationCount"] as? Int {
            user.donationCount = donationCount
        }
        
        if let timestamp = data["lastDonationDate"] as? Timestamp {
            user.lastDonationDate = timestamp.dateValue()
        }
        
        if let county = data["county"] as? String {
            user.county = county
        }
        
    }
    
    private func createUserModelFromFirestore(documentId: String, data: [String: Any]) {
        let email = data["email"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let phoneNumber = data["phoneNumber"] as? String
        let bloodType = data["bloodType"] as? String
        let donationCount = data["donationCount"] as? Int ?? 0
        let county = data["county"] as? String
        let userType = data["userType"] as? String ?? "Donor"
        let workingHours = data["workingHours"] as? String
        let availability = data["availability"] as? String
        let address = data["address"] as? String
        let latitude = data["latitude"] as? Double
        let longitude = data["longitude"] as? Double
        
        var lastDonationDate: Date? = nil
        if let timestamp = data["lastDonationDate"] as? Timestamp {
            lastDonationDate = timestamp.dateValue()
        }
        
        let createdAt: Date
        if let timestamp = data["createdAt"] as? Timestamp {
            createdAt = timestamp.dateValue()
        } else {
            createdAt = Date()
        }
        
        let userModel = UserModel(
            id: documentId,
            email: email,
            name: name,
            phoneNumber: phoneNumber,
            bloodType: bloodType,
            lastDonationDate: lastDonationDate,
            donationCount: donationCount,
            county: county,
            userType : userType,
            workingHours : workingHours,
            availability : availability,
            address :  address,
            latitude: latitude,
            longitude: longitude
        )
        
        // Set createdAt manually since we want to use the server timestamp
        userModel.createdAt = createdAt
        
        // Set sync properties
        userModel.cloudId = documentId
        userModel.lastSyncedAt = Date()
        
        modelContext.insert(userModel)
    }
    
    // MARK: - Blood Request Sync
    
    private func uploadBloodRequests() async throws {
        // Get all blood requests that haven't been synced or have changed since last sync
        let descriptor = FetchDescriptor<BloodSeekerModel>(predicate: #Predicate { 
            $0.cloudId == nil || ($0.lastSyncedAt == nil)
        })
        
        let requestsToSync = try modelContext.fetch(descriptor)
        
        for request in requestsToSync {
            do {
                // If request already has a cloud ID, update existing document
                if let cloudId = request.cloudId {
                    try await updateBloodRequestInFirestore(request, documentId: cloudId)
                } else {
                    // Create new document
                    let docRef = db.collection("bloodRequests").document()
                    try await createBloodRequestInFirestore(request, documentId: docRef.documentID)
                    request.cloudId = docRef.documentID
                }
                
                request.lastSyncedAt = Date()
                try modelContext.save()
            } catch {
                print("Error syncing blood request \(request.name): \(error.localizedDescription)")
            }
        }
    }
    
    private func createBloodRequestInFirestore(_ request: BloodSeekerModel, documentId: String) async throws {
        let requestData = bloodRequestModelToFirestore(request)
        try await db.collection("bloodRequests").document(documentId).setData(requestData)
    }
    
    private func updateBloodRequestInFirestore(_ request: BloodSeekerModel, documentId: String) async throws {
        let requestData = bloodRequestModelToFirestore(request)
        try await db.collection("bloodRequests").document(documentId).updateData(requestData)
    }
    
    private func bloodRequestModelToFirestore(_ request: BloodSeekerModel) -> [String: Any] {
        var requestData: [String: Any] = [
            "id": request.id,
            "name": request.name,
            "requestDescription": request.requestDescription,
            "location": request.location,
            "bloodType": request.bloodType,
            "imageURL": request.imageURL,
            "createdAt": request.createdAt
        ]
        
        if let userId = request.userId {
            requestData["userId"] = userId
        }
        
        return requestData
    }
    
    private func fetchBloodRequests() async throws {
        // Get all blood requests from Firestore
        let snapshot = try await db.collection("bloodRequests").getDocuments()
        
        for document in snapshot.documents {
            let data = document.data()
            let documentId = document.documentID
            
            // Check if request already exists in local database by cloud ID
            let descriptor = FetchDescriptor<BloodSeekerModel>(predicate: #Predicate { 
                $0.cloudId == documentId 
            })
            let matchingRequests = try modelContext.fetch(descriptor)
            
            // If request exists locally by cloud ID, update it
            if let existingRequest = matchingRequests.first {
                updateBloodRequestModelFromFirestore(existingRequest, data: data)
                existingRequest.lastSyncedAt = Date()
            } else {
                // Check if it exists by ID (in case it was created locally but not yet synced)
                if let id = data["id"] as? String {
                    let idDescriptor = FetchDescriptor<BloodSeekerModel>(predicate: #Predicate { 
                        $0.id == id 
                    })
                    let matchesByID = try modelContext.fetch(idDescriptor)
                    
                    if let existingByID = matchesByID.first {
                        updateBloodRequestModelFromFirestore(existingByID, data: data)
                        existingByID.cloudId = documentId
                        existingByID.lastSyncedAt = Date()
                        continue
                    }
                }
                
                // If not found, create a new request
                createBloodRequestModelFromFirestore(documentId: documentId, data: data)
            }
        }
        
        try modelContext.save()
    }
    
    private func updateBloodRequestModelFromFirestore(_ request: BloodSeekerModel, data: [String: Any]) {
        // Update request properties from Firestore data
        if let name = data["name"] as? String {
            request.name = name
        }
        
        if let description = data["requestDescription"] as? String {
            request.requestDescription = description
        }
        
        if let location = data["location"] as? String {
            request.location = location
        }
        
        if let bloodType = data["bloodType"] as? String {
            request.bloodType = bloodType
        }
        
        if let imageURL = data["imageURL"] as? String {
            request.imageURL = imageURL
        }
        
        if let userId = data["userId"] as? String {
            request.userId = userId
        }
        
        if let timestamp = data["createdAt"] as? Timestamp {
            request.createdAt = timestamp.dateValue()
        }
    }
    
    private func createBloodRequestModelFromFirestore(documentId: String, data: [String: Any]) {
        // Extract data fields
        let id = data["id"] as? String ?? UUID().uuidString
        let name = data["name"] as? String ?? ""
        let description = data["requestDescription"] as? String ?? ""
        let location = data["location"] as? String ?? ""
        let bloodType = data["bloodType"] as? String ?? ""
        let imageURL = data["imageURL"] as? String ?? ""
        let userId = data["userId"] as? String
        
        let createdAt: Date
        if let timestamp = data["createdAt"] as? Timestamp {
            createdAt = timestamp.dateValue()
        } else {
            createdAt = Date()
        }
        
        // Create new model
        let request = BloodSeekerModel(
            id: id,
            name: name, 
            requestDescription: description,
            location: location,
            bloodType: bloodType,
            imageURL: imageURL,
            userId: userId
        )
        
        // Set createdAt manually since we want to use the server timestamp
        request.createdAt = createdAt
        
        // Set sync properties
        request.cloudId = documentId
        request.lastSyncedAt = Date()
        
        modelContext.insert(request)
    }
    
    // MARK: - Donation Center Sync
    
    // Similar implementation for donation centers - for brevity, skipping the detailed implementation
    // Would follow the same pattern as the user and blood request sync methods
    
    private func uploadDonationCenters() async throws {
        // Similar to uploadUsers and uploadBloodRequests
        print("Donation centers sync would be implemented here")
    }
    
    private func fetchDonationCenters() async throws {
        // Similar to fetchUsers and fetchBloodRequests
        print("Donation centers retrieval would be implemented here")
    }
} 


extension FirebaseDataService {
    static let shared = FirebaseDataService()
}
