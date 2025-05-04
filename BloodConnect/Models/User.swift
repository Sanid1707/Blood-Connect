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
    let userType: String // "donor" or "organization"
    let availability: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let organizationDescription: String?
    let workingHours: String?
    let eircode: String?
    
    init(id: String?=nil, 
         email: String, 
         name: String, 
         phoneNumber: String? = nil, 
         bloodType: BloodType? = nil, 
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
