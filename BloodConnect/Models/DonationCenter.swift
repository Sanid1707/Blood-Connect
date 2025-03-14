//
//  DonationCenter.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 14/03/2025.
//
import Foundation
import CoreLocation

struct DonationCenter: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let phoneNumber: String
    let email: String?
    let website: String?
    let latitude: Double
    let longitude: Double
    let operatingHours: [OperatingHours]
    let acceptedBloodTypes: [BloodType]
    let currentNeed: [BloodNeed]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var formattedAddress: String {
        return "\(address), \(city), \(state) \(zipCode)"
    }
}

struct OperatingHours: Codable {
    let day: Weekday
    let openTime: String
    let closeTime: String
    let isClosed: Bool
}

enum Weekday: String, Codable, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var displayName: String {
        return self.rawValue
    }
}

enum BloodNeed: String, Codable, CaseIterable {
    case critical = "Critical"
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    case none = "None"
    
    var displayName: String {
        return self.rawValue
    }
}
