import Foundation
import CoreLocation
import SwiftData
import Combine
import FirebaseFirestore
import UserNotifications

@MainActor
class BloodRequestService {
    private let db = Firestore.firestore()
    private let modelContext: ModelContext
    private let notificationManager = NotificationManager()
    private let userService = UserService()
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext ?? DatabaseManager.shared.mainContext
    }
    
    // Create a new blood request
    func createBloodRequest(_ request: BloodRequest) -> AnyPublisher<BloodRequest, Error> {
        return Future<BloodRequest, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "BloodRequestService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Service unavailable"])))
                return
            }
            
            Task {
                do {
                    // Convert to entity and save to SwiftData
                    let entity = request.toEntity()
                    self.modelContext.insert(entity)
                    try self.modelContext.save()
                    
                    // Save to Firebase
                    try await self.saveBloodRequestToFirebase(request)
                    
                    // Find eligible donors and notify them
                    await self.notifyEligibleDonors(request)
                    
                    promise(.success(request))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Get all blood requests
    func getAllBloodRequests() -> [BloodRequest] {
        let descriptor = FetchDescriptor<BloodRequestEntity>()
        do {
            let entities = try modelContext.fetch(descriptor)
            // Convert entities to DTOs
            return entities.map { $0.toBloodRequest() }
        } catch {
            print("Error fetching blood requests: \(error)")
            return []
        }
    }
    
    // Get blood requests for a specific user
    func getBloodRequestsForUser(userId: String) -> [BloodRequest] {
        let predicate = #Predicate<BloodRequestEntity> { entity in 
            entity.requestorId == userId
        }
        let descriptor = FetchDescriptor<BloodRequestEntity>(predicate: predicate)
        
        do {
            let entities = try modelContext.fetch(descriptor)
            // Convert entities to DTOs
            return entities.map { $0.toBloodRequest() }
        } catch {
            print("Error fetching blood requests for user: \(error)")
            return []
        }
    }
    
    // Update an existing blood request
    func updateBloodRequest(_ request: BloodRequest) -> AnyPublisher<BloodRequest, Error> {
        return Future<BloodRequest, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "BloodRequestService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Service unavailable"])))
                return
            }
            
            Task {
                do {
                    // Find the entity
                    let requestId = request.id
                    let predicate = #Predicate<BloodRequestEntity> { entity in 
                        entity.id == requestId
                    }
                    let descriptor = FetchDescriptor<BloodRequestEntity>(predicate: predicate)
                    let entities = try self.modelContext.fetch(descriptor)
                    
                    if let entity = entities.first {
                        // Update entity properties
                        entity.patientName = request.patientName
                        entity.bloodGroup = request.bloodGroup
                        entity.unitsRequired = request.unitsRequired
                        entity.mobileNumber = request.mobileNumber
                        entity.gender = request.gender
                        entity.requestDate = request.requestDate
                        entity.requestorId = request.requestorId
                        entity.requestorName = request.requestorName
                        entity.searchRadius = request.searchRadius
                        entity.latitude = request.latitude
                        entity.longitude = request.longitude
                        entity.isUrgent = request.isUrgent
                        entity.status = request.status
                        entity.updatedAt = Date()
                        
                        // Save changes
                        try self.modelContext.save()
                        
                        // Update in Firebase
                        try await self.updateBloodRequestInFirebase(request)
                        
                        promise(.success(request))
                    } else {
                        promise(.failure(NSError(domain: "BloodRequestService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Blood request not found"])))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Delete a blood request
    func deleteBloodRequest(id: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "BloodRequestService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Service unavailable"])))
                return
            }
            
            Task {
                do {
                    // Find the request locally
                    let requestId = id
                    let predicate = #Predicate<BloodRequestEntity> { entity in 
                        entity.id == requestId
                    }
                    let descriptor = FetchDescriptor<BloodRequestEntity>(predicate: predicate)
                    
                    let entities = try self.modelContext.fetch(descriptor)
                    if let entity = entities.first {
                        // Delete locally
                        self.modelContext.delete(entity)
                        try self.modelContext.save()
                        
                        // Delete from Firebase
                        try await self.deleteBloodRequestFromFirebase(id)
                        
                        promise(.success(()))
                    } else {
                        promise(.failure(NSError(domain: "BloodRequestService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Blood request not found"])))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Firebase Operations
    
    private func saveBloodRequestToFirebase(_ request: BloodRequest) async throws {
        let requestData: [String: Any] = [
            "id": request.id,
            "patientName": request.patientName,
            "bloodGroup": request.bloodGroup,
            "unitsRequired": request.unitsRequired,
            "mobileNumber": request.mobileNumber,
            "gender": request.gender,
            "requestDate": request.requestDate,
            "requestorId": request.requestorId ?? "",
            "requestorName": request.requestorName,
            "searchRadius": request.searchRadius,
            "latitude": request.latitude,
            "longitude": request.longitude,
            "isUrgent": request.isUrgent,
            "status": request.status,
            "createdAt": request.createdAt,
            "updatedAt": request.updatedAt
        ]
        
        try await db.collection("bloodRequests").document(request.id).setData(requestData)
    }
    
    private func updateBloodRequestInFirebase(_ request: BloodRequest) async throws {
        let requestData: [String: Any] = [
            "patientName": request.patientName,
            "bloodGroup": request.bloodGroup,
            "unitsRequired": request.unitsRequired,
            "mobileNumber": request.mobileNumber,
            "gender": request.gender,
            "requestDate": request.requestDate,
            "requestorName": request.requestorName,
            "searchRadius": request.searchRadius,
            "latitude": request.latitude,
            "longitude": request.longitude,
            "isUrgent": request.isUrgent,
            "status": request.status,
            "updatedAt": request.updatedAt
        ]
        
        try await db.collection("bloodRequests").document(request.id).updateData(requestData)
    }
    
    private func deleteBloodRequestFromFirebase(_ id: String) async throws {
        try await db.collection("bloodRequests").document(id).delete()
    }
    
    // MARK: - Sync with Firebase
    
    func syncBloodRequestsWithFirebase() async {
        do {
            let querySnapshot = try await db.collection("bloodRequests").getDocuments()
            
            for document in querySnapshot.documents {
                let data = document.data()
                
                guard let id = data["id"] as? String,
                      let patientName = data["patientName"] as? String,
                      let bloodGroup = data["bloodGroup"] as? String,
                      let unitsRequired = data["unitsRequired"] as? Int,
                      let mobileNumber = data["mobileNumber"] as? String,
                      let gender = data["gender"] as? String,
                      let requestorName = data["requestorName"] as? String,
                      let searchRadius = data["searchRadius"] as? Double,
                      let latitude = data["latitude"] as? Double,
                      let longitude = data["longitude"] as? Double,
                      let isUrgent = data["isUrgent"] as? Bool,
                      let status = data["status"] as? String else {
                    print("Error parsing blood request data for document: \(document.documentID)")
                    continue
                }
                
                // Convert Timestamp to Date
                let requestDate = (data["requestDate"] as? Timestamp)?.dateValue() ?? Date()
                let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
                let updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                let requestorId = data["requestorId"] as? String
                
                // Create a BloodRequest object
                let bloodRequest = BloodRequest(
                    id: id,
                    patientName: patientName,
                    bloodGroup: bloodGroup,
                    unitsRequired: unitsRequired,
                    mobileNumber: mobileNumber,
                    gender: gender,
                    requestDate: requestDate,
                    requestorId: requestorId,
                    requestorName: requestorName,
                    searchRadius: searchRadius,
                    latitude: latitude,
                    longitude: longitude,
                    isUrgent: isUrgent,
                    status: status,
                    createdAt: createdAt,
                    updatedAt: updatedAt
                )
                
                // Check if request already exists locally
                let documentId = id
                let predicate = #Predicate<BloodRequestEntity> { entity in 
                    entity.id == documentId
                }
                let descriptor = FetchDescriptor<BloodRequestEntity>(predicate: predicate)
                
                let existingEntities = try modelContext.fetch(descriptor)
                
                if let existingEntity = existingEntities.first {
                    // Update existing entity
                    existingEntity.patientName = patientName
                    existingEntity.bloodGroup = bloodGroup
                    existingEntity.unitsRequired = unitsRequired
                    existingEntity.mobileNumber = mobileNumber
                    existingEntity.gender = gender
                    existingEntity.requestDate = requestDate
                    existingEntity.requestorId = requestorId
                    existingEntity.requestorName = requestorName
                    existingEntity.searchRadius = searchRadius
                    existingEntity.latitude = latitude
                    existingEntity.longitude = longitude
                    existingEntity.isUrgent = isUrgent
                    existingEntity.status = status
                    existingEntity.updatedAt = updatedAt
                } else {
                    // Create new entity from the DTO
                    modelContext.insert(bloodRequest.toEntity())
                }
            }
            
            // Save changes
            try modelContext.save()
            
        } catch {
            print("Error syncing blood requests with Firebase: \(error)")
        }
    }
    
    // MARK: - Notification Methods
    
    // TEMPORARY: Modified to send notifications to all users for testing
    private func notifyEligibleDonors(_ request: BloodRequest) async {
        print("🔔 TESTING MODE: Sending notifications to ALL users regardless of eligibility")
        
        // Get all users (not just donors)
        let allUsers = userService.getAllUsers()
        
        // Send notifications to all users
        for user in allUsers {
            // Send notification to every user
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "🧪 TEST: Blood Request Notification"
            notificationContent.body = "This is a test notification for blood type \(request.bloodGroup). If you see this, notifications are working!"
            notificationContent.sound = .default
            notificationContent.userInfo = ["requestId": request.id, "isTest": true]
            
            // Create a unique identifier for this notification
            let notificationId = "test_bloodRequest_\(request.id)_\(user.id ?? UUID().uuidString)_\(Date().timeIntervalSince1970)"
            
            // Send the notification immediately
            notificationManager.scheduleNotification(
                identifier: notificationId,
                content: notificationContent,
                trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            )
            
            print("📱 Scheduled TEST notification for user: \(user.name)")
        }
        
        print("📣 Sent test notifications to \(allUsers.count) users")
        
        // Also send a notification to the current device
        sendTestNotificationToCurrentDevice(request: request)
    }
    
    // New test function to send a notification to the current device
    private func sendTestNotificationToCurrentDevice(request: BloodRequest) {
        let testContent = UNMutableNotificationContent()
        testContent.title = "🔔 DIRECT TEST NOTIFICATION"
        testContent.body = "This notification bypasses all checks. If you see this but not others, check user data."
        testContent.sound = .default
        testContent.userInfo = ["directTest": true, "timestamp": Date().timeIntervalSince1970]
        
        // Use a very unique ID to avoid conflicts
        let directTestId = "direct_test_\(UUID().uuidString)"
        
        notificationManager.scheduleNotification(
            identifier: directTestId,
            content: testContent,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        )
        
        print("⚡ Direct test notification scheduled - should appear in 3 seconds")
    }
    
    // Add a public test function that can be called directly
    func testNotifications() {
        let testRequest = BloodRequest(
            patientName: "Test Patient",
            bloodGroup: "O+",
            unitsRequired: 2,
            mobileNumber: "123-456-7890",
            gender: "Other",
            requestDate: Date(),
            requestorName: "Test Requestor",
            searchRadius: 50.0,
            latitude: 53.3498,
            longitude: -6.2603,
            isUrgent: true
        )
        
        Task {
            await notifyEligibleDonors(testRequest)
        }
        
        print("🧪 Test notification sequence initiated")
    }
    
    // Helper methods moved from BloodRequestEntity to this service
    private func isDonorEligible(donor: User, donorLocation: CLLocationCoordinate2D, request: BloodRequest) -> Bool {
        // TEMPORARILY DISABLED FOR TESTING - Always return true
        return true
        
        /* Original implementation:
        // Check blood group compatibility
        guard let donorBloodType = donor.bloodType else {
            return false
        }
        
        let isBloodCompatible = isBloodGroupCompatible(requestBloodType: request.bloodGroup, donorBloodType: donorBloodType.rawValue)
        
        // Check if donor is within search radius
        let requestLocation = CLLocationCoordinate2D(latitude: request.latitude, longitude: request.longitude)
        let isWithinRadius = isLocationWithinRadius(donorLocation: donorLocation, requestLocation: requestLocation, searchRadius: request.searchRadius)
        
        return isBloodCompatible && isWithinRadius
        */
    }
    
    // Helper function to check blood group compatibility
    private func isBloodGroupCompatible(requestBloodType: String, donorBloodType: String) -> Bool {
        // Simple exact match for now - in a real app, implement full compatibility rules
        return requestBloodType == donorBloodType
    }
    
    // Helper function to check if donor is within the search radius
    private func isLocationWithinRadius(donorLocation: CLLocationCoordinate2D, requestLocation: CLLocationCoordinate2D, searchRadius: Double) -> Bool {
        let donorCLLocation = CLLocation(latitude: donorLocation.latitude, longitude: donorLocation.longitude)
        let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        
        // Calculate distance in meters
        let distanceInMeters = donorCLLocation.distance(from: requestCLLocation)
        
        // Convert search radius from km to meters and compare
        return distanceInMeters <= (searchRadius * 1000)
    }
} 
