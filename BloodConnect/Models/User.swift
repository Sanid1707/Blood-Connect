//
//  User.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String
    let phoneNumber: String?
    let bloodType: BloodType?
    let lastDonationDate: Date?
    let donationCount: Int
    
    init(id: String, email: String, name: String, phoneNumber: String? = nil, bloodType: BloodType? = nil, lastDonationDate: Date? = nil, donationCount: Int = 0) {
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.bloodType = bloodType
        self.lastDonationDate = lastDonationDate
        self.donationCount = donationCount
    }
}

enum BloodType: String, Codable, CaseIterable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case abPositive = "AB+"
    case abNegative = "AB-"
    case oPositive = "O+"
    case oNegative = "O-"
    
    var displayName: String {
        return self.rawValue
    }
}
