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
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
} 
