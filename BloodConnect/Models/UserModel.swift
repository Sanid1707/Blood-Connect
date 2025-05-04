import Foundation
import SwiftData

@Model
final class UserModel {
    var id: String
    var email: String
    var name: String
    var phoneNumber: String?
    var bloodType: String?
    var lastDonationDate: Date?
    var donationCount: Int
    var county: String?
    var createdAt: Date
    
    // Cloud sync properties
    var cloudId: String?
    var lastSyncedAt: Date?
    
    // User type - "donor" or "organization"
    var userType: String
    var availability: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var organizationDescription: String?
    var workingHours: String?
    var eircode: String?


    init(id: String = UUID().uuidString,
         email: String,
         name: String,
         phoneNumber: String? = nil,
         bloodType: String? = nil,
         lastDonationDate: Date? = nil,
         donationCount: Int = 0,
         county: String? = nil,
         userType: String,
         availability: String? = nil,
         address: String? = nil,
         latitude: Double? = nil,
         longitude: Double? = nil,
         organizationDescription: String? = nil,
         workingHours: String? = nil,
         eircode: String? = nil) {
        
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.bloodType = bloodType
        self.lastDonationDate = lastDonationDate
        self.donationCount = donationCount
        self.county = county
        self.userType = userType
        self.availability = availability
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.organizationDescription = organizationDescription
        self.workingHours = workingHours
        self.eircode = eircode
        self.createdAt = Date()
        self.cloudId = nil
        self.lastSyncedAt = nil
    }

    // Convert from User struct
    convenience init(from user: User) {
        self.init(
            id: user.id ?? UUID().uuidString,
            email: user.email,
            name: user.name,
            phoneNumber: user.phoneNumber,
            bloodType: user.bloodType?.rawValue,
            lastDonationDate: user.lastDonationDate,
            donationCount: user.donationCount,
            county: user.county,
            userType: user.userType,
            availability: user.availability,
            address: user.address,
            latitude: user.latitude,
            longitude: user.longitude,
            organizationDescription: user.organizationDescription,
            workingHours: user.workingHours,
            eircode: user.eircode
        )
    }

    // Convert to User struct
    func toUser() -> User {
        return User(
            id: self.id,
            email: self.email,
            name: self.name,
            phoneNumber: self.phoneNumber,
            bloodType: self.bloodType != nil ? BloodType(rawValue: self.bloodType!) : nil,
            lastDonationDate: self.lastDonationDate,
            donationCount: self.donationCount,
            county: self.county,
            userType: self.userType,
            availability: self.availability,
            address: self.address,
            latitude: self.latitude,
            longitude: self.longitude,
            organizationDescription: self.organizationDescription,
            workingHours: self.workingHours,
            eircode: self.eircode
        )
    }
}
