import Foundation
import SwiftData

@Model
final class BloodSeekerModel {
    var id: String
    var name: String
    var requestDescription: String
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
         requestDescription: String,
         location: String,
         bloodType: String,
         imageURL: String,
         userId: String? = nil) {
        self.id = id
        self.name = name
        self.requestDescription = requestDescription
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
            requestDescription: bloodSeeker.description,
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
            description: self.requestDescription,
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
