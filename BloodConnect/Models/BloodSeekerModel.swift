import Foundation
import SwiftData
import CoreLocation

@Model
final class BloodSeekerModel {
    var id: String
    var name: String
    var seekerDescription: String
    var location: String
    var bloodType: String
    var imageURL: String
    var createdAt: Date
    var userId: String?
    
    // Cloud sync properties
    var cloudId: String?
    var lastSyncedAt: Date?
    
    init(id: String = UUID().uuidString,
         name: String,
         seekerDescription: String,
         location: String,
         bloodType: String,
         imageURL: String,
         userId: String? = nil) {
        self.id = id
        self.name = name
        self.seekerDescription = seekerDescription
        self.location = location
        self.bloodType = bloodType
        self.imageURL = imageURL
        self.createdAt = Date()
        self.userId = userId
        self.cloudId = nil
        self.lastSyncedAt = nil
    }
    
    // Convert from regular BloodSeeker struct
    convenience init(from bloodSeeker: BloodSeeker, userId: String? = nil) {
        self.init(
            id: bloodSeeker.id.uuidString,
            name: bloodSeeker.name,
            seekerDescription: bloodSeeker.seekerDescription,
            location: bloodSeeker.location,
            bloodType: bloodSeeker.bloodType,
            imageURL: bloodSeeker.imageURL,
            userId: userId
        )
    }
    
    // Convert to regular BloodSeeker struct
    func toBloodSeeker() -> BloodSeeker {
        return BloodSeeker(
            name: self.name,
            seekerDescription: self.seekerDescription,
            timeAgo: self.getTimeAgo(),
            location: self.location,
            bloodType: self.bloodType,
            imageURL: self.imageURL
        )
    }
    
    private func getTimeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: createdAt, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "Day" : "Days") Ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) \(hours == 1 ? "Hour" : "Hours") Ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "Min" : "Mins") Ago"
        } else {
            return "Just Now"
        }
    }
}

@Model
final class BloodRequestModel {
    var id: String
    var title: String
    var requestDescription: String
    var bloodType: String
    var urgency: String // "Low", "Medium", "High", "Critical"
    var status: String // "Active", "Fulfilled", "Expired"
    
    // Location data for the request
    var location: String
    var latitude: Double
    var longitude: Double
    var radiusKm: Double // Search radius in kilometers
    
    // Reference to requesting user (organization)
    var userId: String
    var organizationName: String
    
    // Timestamps
    var createdAt: Date
    var expiresAt: Date?
    
    // Cloud sync properties
    var cloudId: String?
    var lastSyncedAt: Date?
    
    init(id: String = UUID().uuidString,
         title: String,
         requestDescription: String,
         bloodType: String,
         urgency: String = "Medium",
         status: String = "Active",
         location: String,
         latitude: Double,
         longitude: Double,
         radiusKm: Double,
         userId: String,
         organizationName: String,
         expiresAt: Date? = nil) {
        
        self.id = id
        self.title = title
        self.requestDescription = requestDescription
        self.bloodType = bloodType
        self.urgency = urgency
        self.status = status
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.radiusKm = radiusKm
        self.userId = userId
        self.organizationName = organizationName
        self.createdAt = Date()
        self.expiresAt = expiresAt
        self.cloudId = nil
        self.lastSyncedAt = nil
    }
    
    // Helper method to convert to a UI-friendly struct
    func toBloodRequest() -> BloodRequest {
        return BloodRequest(
            id: self.id,
            title: self.title,
            requestDescription: self.requestDescription,
            bloodType: self.bloodType,
            urgency: self.urgency,
            status: self.status,
            location: self.location,
            latitude: self.latitude,
            longitude: self.longitude,
            radiusKm: self.radiusKm,
            organizationName: self.organizationName,
            timeAgo: getTimeAgo(),
            distance: nil // This would be calculated based on user's current location
        )
    }
    
    private func getTimeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: createdAt, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "Day" : "Days") Ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) \(hours == 1 ? "Hour" : "Hours") Ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "Min" : "Mins") Ago"
        } else {
            return "Just Now"
        }
    }
}

// UI presentation struct
struct BloodRequest: Identifiable {
    let id: String
    let title: String
    let requestDescription: String
    let bloodType: String
    let urgency: String
    let status: String
    let location: String
    let latitude: Double
    let longitude: Double
    let radiusKm: Double
    let organizationName: String
    let timeAgo: String
    let distance: Double? // Distance from user, if available
    
    // Additional properties needed by BloodRequestService
    var patientName: String = ""
    var bloodGroup: String = ""
    var unitsRequired: Int = 0
    var mobileNumber: String = ""
    var gender: String = ""
    var requestDate: Date = Date()
    var requestorId: String? = nil
    var requestorName: String = ""
    var searchRadius: Double = 0.0
    var isUrgent: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // Main initializer
    init(id: String, title: String, requestDescription: String, bloodType: String, urgency: String, status: String, location: String, latitude: Double, longitude: Double, radiusKm: Double, organizationName: String, timeAgo: String, distance: Double?) {
        self.id = id
        self.title = title
        self.requestDescription = requestDescription
        self.bloodType = bloodType
        self.urgency = urgency
        self.status = status
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.radiusKm = radiusKm
        self.organizationName = organizationName
        self.timeAgo = timeAgo
        self.distance = distance
    }
    
    // Firebase data initializer used in BloodRequestService:syncBloodRequestsWithFirebase
    init(id: String, patientName: String, bloodGroup: String, unitsRequired: Int, mobileNumber: String, gender: String, 
         requestDate: Date, requestorId: String?, requestorName: String, searchRadius: Double, 
         latitude: Double, longitude: Double, isUrgent: Bool, status: String, 
         createdAt: Date, updatedAt: Date) {
        
        self.id = id
        self.title = "Blood Request for \(patientName)"
        self.requestDescription = "Blood donation needed for \(patientName), \(bloodGroup) blood group"
        self.bloodType = bloodGroup
        self.urgency = isUrgent ? "Critical" : "Medium"
        self.status = status
        self.location = "Unknown Location" // Could be derived from coordinates if needed
        self.latitude = latitude
        self.longitude = longitude
        self.radiusKm = searchRadius
        self.organizationName = requestorName
        self.timeAgo = Self.calculateTimeAgo(from: createdAt)
        self.distance = nil
        
        // Set additional properties
        self.patientName = patientName
        self.bloodGroup = bloodGroup
        self.unitsRequired = unitsRequired
        self.mobileNumber = mobileNumber
        self.gender = gender
        self.requestDate = requestDate
        self.requestorId = requestorId
        self.requestorName = requestorName
        self.searchRadius = searchRadius
        self.isUrgent = isUrgent
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // Test notification initializer used in BloodRequestService:testNotifications
    init(patientName: String, bloodGroup: String, unitsRequired: Int, mobileNumber: String, gender: String,
         requestDate: Date, requestorName: String, searchRadius: Double, latitude: Double, longitude: Double, isUrgent: Bool) {
        
        self.id = UUID().uuidString
        self.title = "Test Request for \(patientName)"
        self.requestDescription = "Test blood donation needed"
        self.bloodType = bloodGroup
        self.urgency = isUrgent ? "Critical" : "Medium"
        self.status = "Active"
        self.location = "Test Location"
        self.latitude = latitude
        self.longitude = longitude
        self.radiusKm = searchRadius
        self.organizationName = requestorName
        self.timeAgo = "Just Now"
        self.distance = nil
        
        // Set additional properties
        self.patientName = patientName
        self.bloodGroup = bloodGroup
        self.unitsRequired = unitsRequired
        self.mobileNumber = mobileNumber
        self.gender = gender
        self.requestDate = requestDate
        self.requestorId = nil
        self.requestorName = requestorName
        self.searchRadius = searchRadius
        self.isUrgent = isUrgent
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Helper method to calculate time ago
    private static func calculateTimeAgo(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "Day" : "Days") Ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) \(hours == 1 ? "Hour" : "Hours") Ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "Min" : "Mins") Ago"
        } else {
            return "Just Now"
        }
    }
    
    // Convert to BloodRequestEntity for database storage
    func toEntity() -> BloodRequestEntity {
        let entity = BloodRequestEntity()
        entity.id = self.id
        entity.title = self.title
        entity.requestDescription = self.requestDescription
        entity.bloodType = self.bloodType
        entity.urgency = self.urgency
        entity.status = self.status
        entity.location = self.location
        entity.latitude = self.latitude
        entity.longitude = self.longitude
        entity.radiusKm = self.radiusKm
        entity.organizationName = self.organizationName
        
        // Additional properties
        entity.patientName = self.patientName
        entity.bloodGroup = self.bloodGroup
        entity.unitsRequired = self.unitsRequired
        entity.mobileNumber = self.mobileNumber
        entity.gender = self.gender
        entity.requestDate = self.requestDate
        entity.requestorId = self.requestorId
        entity.requestorName = self.requestorName
        entity.searchRadius = self.searchRadius
        entity.isUrgent = self.isUrgent
        entity.createdAt = self.createdAt
        entity.updatedAt = self.updatedAt
        
        return entity
    }
}

// Add the BloodRequestEntity model
@Model
final class BloodRequestEntity {
    @Attribute(.unique) var id: String = UUID().uuidString
    var title: String = ""
    var requestDescription: String = ""
    var bloodType: String = ""
    var urgency: String = ""
    var status: String = ""
    var location: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var radiusKm: Double = 0.0
    var organizationName: String = ""
    
    // Additional properties
    var patientName: String = ""
    var bloodGroup: String = ""
    var unitsRequired: Int = 0
    var mobileNumber: String = ""
    var gender: String = ""
    var requestDate: Date = Date()
    var requestorId: String? = nil
    var requestorName: String = ""
    var searchRadius: Double = 0.0
    var isUrgent: Bool = false
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    init() {
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Convert entity to DTO
    func toBloodRequest() -> BloodRequest {
        var request = BloodRequest(
            id: self.id,
            title: self.title,
            requestDescription: self.requestDescription,
            bloodType: self.bloodType,
            urgency: self.urgency,
            status: self.status,
            location: self.location,
            latitude: self.latitude,
            longitude: self.longitude,
            radiusKm: self.radiusKm,
            organizationName: self.organizationName,
            timeAgo: getTimeAgo(),
            distance: nil
        )
        
        // Set additional properties
        request.patientName = self.patientName
        request.bloodGroup = self.bloodGroup
        request.unitsRequired = self.unitsRequired
        request.mobileNumber = self.mobileNumber
        request.gender = self.gender
        request.requestDate = self.requestDate
        request.requestorId = self.requestorId
        request.requestorName = self.requestorName
        request.searchRadius = self.searchRadius
        request.isUrgent = self.isUrgent
        request.createdAt = self.createdAt
        request.updatedAt = self.updatedAt
        
        return request
    }
    
    private func getTimeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: createdAt, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "Day" : "Days") Ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours) \(hours == 1 ? "Hour" : "Hours") Ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "Min" : "Mins") Ago"
        } else {
            return "Just Now"
        }
    }
} 
