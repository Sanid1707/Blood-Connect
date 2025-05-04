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
    var distance: Double?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var formattedAddress: String {
        return "\(address), \(city), \(state) \(zipCode)"
    }
    
    // Add formatted hours property
    var formattedHours: String {
        let today = Calendar.current.component(.weekday, from: Date())
        let weekday = mapWeekdayToEnum(today)
        
        if let todayHours = operatingHours.first(where: { $0.day.rawValue == weekday.rawValue }) {
            if todayHours.isClosed {
                return "Closed Today"
            } else {
                return "Today: \(todayHours.openTime) - \(todayHours.closeTime)"
            }
        }
        return "Hours not available"
    }
    
    // Helper to map Calendar.Component.weekday to our Weekday enum
    private func mapWeekdayToEnum(_ calendarWeekday: Int) -> Weekday {
        switch calendarWeekday {
        case 1: return .sunday
        case 2: return .monday
        case 3: return .tuesday
        case 4: return .wednesday
        case 5: return .thursday
        case 6: return .friday
        case 7: return .saturday
        default: return .monday
        }
    }
    
    // Factory method for creating a DonationCenter for map view with minimal required fields
    static func forMapView(
        id: String,
        name: String,
        address: String,
        phoneNumber: String,
        coordinate: CLLocationCoordinate2D,
        operatingHours: [OperatingHours]
    ) -> DonationCenter {
        return DonationCenter(
            id: id,
            name: name,
            address: address,
            city: "", // These can be empty for map preview purposes
            state: "",
            zipCode: "",
            phoneNumber: phoneNumber,
            email: nil,
            website: nil,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            operatingHours: operatingHours,
            acceptedBloodTypes: [],
            currentNeed: []
        )
    }
    
    // Function to calculate distance from user location
    func withDistance(from userLocation: CLLocationCoordinate2D) -> DonationCenter {
        let centerLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let userLoc = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let distanceInMeters = centerLocation.distance(from: userLoc)
        
        // Return a new instance with the distance set
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
            operatingHours: self.operatingHours,
            acceptedBloodTypes: self.acceptedBloodTypes,
            currentNeed: self.currentNeed,
            distance: distanceInMeters
        )
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
