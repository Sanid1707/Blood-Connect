import Foundation
import SwiftData
import CoreLocation

@Model
final class DonationCenterModel {
    var id: String
    var name: String
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var phoneNumber: String
    var email: String?
    var website: String?
    var latitude: Double
    var longitude: Double
    
    // Relationships
    @Relationship(deleteRule: .cascade)
    var operatingHours: [OperatingHoursModel] = []
    
    var acceptedBloodTypes: [String] = []
    var currentNeedLevels: [String] = []
    var createdAt: Date
    
    init(id: String = UUID().uuidString,
         name: String,
         address: String,
         city: String,
         state: String,
         zipCode: String,
         phoneNumber: String,
         email: String? = nil,
         website: String? = nil,
         latitude: Double,
         longitude: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.phoneNumber = phoneNumber
        self.email = email
        self.website = website
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = Date()
    }
    
    // Convert from regular DonationCenter struct
    convenience init(from center: DonationCenter) {
        self.init(
            id: center.id,
            name: center.name,
            address: center.address,
            city: center.city,
            state: center.state,
            zipCode: center.zipCode,
            phoneNumber: center.phoneNumber,
            email: center.email,
            website: center.website,
            latitude: center.latitude,
            longitude: center.longitude
        )
        
        // Convert operating hours
        self.operatingHours = center.operatingHours.map { 
            OperatingHoursModel(
                day: $0.day.rawValue,
                openTime: $0.openTime,
                closeTime: $0.closeTime,
                isClosed: $0.isClosed
            ) 
        }
        
        // Convert blood types and need levels
        self.acceptedBloodTypes = center.acceptedBloodTypes.map { $0.rawValue }
        self.currentNeedLevels = center.currentNeed.map { $0.rawValue }
    }
    
    // Convert to regular DonationCenter struct
    func toDonationCenter() -> DonationCenter {
        let operatingHours = self.operatingHours.map { hour -> OperatingHours in
            let weekday = Weekday(rawValue: hour.day) ?? .monday
            return OperatingHours(
                day: weekday,
                openTime: hour.openTime,
                closeTime: hour.closeTime,
                isClosed: hour.isClosed
            )
        }
        
        let bloodTypes = self.acceptedBloodTypes.compactMap { BloodType(rawValue: $0) }
        let needLevels = self.currentNeedLevels.compactMap { BloodNeed(rawValue: $0) }
        
        return DonationCenter(
            id: self.id,
            name: self.name,
            address: self.address,
            city: self.city,
            state: self.state,
            zipCode: self.zipCode,
            phoneNumber: self.phoneNumber,
            email: self.email,
            website: self.website,
            latitude: self.latitude,
            longitude: self.longitude,
            operatingHours: operatingHours,
            acceptedBloodTypes: bloodTypes,
            currentNeed: needLevels
        )
    }
}

@Model
final class OperatingHoursModel {
    var id: String
    var day: String  // Store as String, will map to Weekday enum
    var openTime: String
    var closeTime: String
    var isClosed: Bool
    
    init(id: String = UUID().uuidString,
         day: String,
         openTime: String,
         closeTime: String,
         isClosed: Bool) {
        self.id = id
        self.day = day
        self.openTime = openTime
        self.closeTime = closeTime
        self.isClosed = isClosed
    }
} 