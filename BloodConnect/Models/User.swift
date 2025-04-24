//
//  User.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String?
    let email: String
    let name: String
    let phoneNumber: String?
    let bloodType: BloodType?
    let lastDonationDate: Date?
    let donationCount: Int
    let county: String?
    let userType: String
    let workingHours: String?
    let availability: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    init(id: String?=nil, email: String, name: String, phoneNumber: String? = nil, bloodType: BloodType? = nil, lastDonationDate: Date? = nil, donationCount: Int = 0,county:String?=nil,userType: String,
         workingHours: String? = nil,
         availability: String? = nil,
         address: String? = nil, latitude: Double? = nil,
         longitude: Double? = nil) {
        self.id = id
        self.email = email
        self.name = name
        self.phoneNumber = phoneNumber
        self.bloodType = bloodType
        self.lastDonationDate = lastDonationDate
        self.donationCount = donationCount
        self.county = county
        self.userType = userType
        self.workingHours = workingHours
        self.availability = availability
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
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
