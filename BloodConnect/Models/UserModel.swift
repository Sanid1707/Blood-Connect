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
    var country: String?
    var createdAt: Date
    
    init(id: String = UUID().uuidString, 
         email: String,
         name: String,
         phoneNumber: String? = nil,
         bloodType: String? = nil,
         lastDonationDate: Date? = nil,
         donationCount: Int = 0,
         country: String? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.bloodType = bloodType
        self.lastDonationDate = lastDonationDate
        self.donationCount = donationCount
        self.country = country
        self.createdAt = Date()
    }
    
    // Convert from regular User struct
    convenience init(from user: User) {
        self.init(
            id: user.id ?? UUID().uuidString,
            email: user.email,
            name: user.name,
            phoneNumber: user.phoneNumber,
            bloodType: user.bloodType?.rawValue,
            lastDonationDate: user.lastDonationDate,
            donationCount: user.donationCount,
            country: user.country
        )
    }
    
    // Convert to regular User struct
    func toUser() -> User {
        return User(
            id: self.id,
            email: self.email,
            name: self.name,
            phoneNumber: self.phoneNumber,
            bloodType: self.bloodType != nil ? BloodType(rawValue: self.bloodType!) : nil,
            lastDonationDate: self.lastDonationDate,
            donationCount: self.donationCount,
            country: self.country
        )
    }
} 