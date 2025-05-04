////
////  SampleDataService.swift
////  BloodConnect
////
////  Created by Sanidhya Pandey on 24/04/2025.
////
//
//import Foundation
//import SwiftData
//import FirebaseFirestore
//
//@MainActor
//class SampleDataService {
//    // MARK: - Properties
//    private let modelContext: ModelContext
//    private let syncService: FirebaseDataService
//    
//    // MARK: - Initialization
//    init(modelContext: ModelContext? = nil) {
//        if let modelContext = modelContext {
//            self.modelContext = modelContext
//        } else {
//            self.modelContext = DatabaseManager.shared.mainContext
//        }
//        
//        self.syncService = FirebaseDataService(modelContext: self.modelContext)
//    }
//    
//    // MARK: - Public Methods
//    
//    /// Creates sample data for testing purposes
//    func createSampleData() async throws {
//        // First check if we already have data
//        let userDescriptor = FetchDescriptor<UserModel>()
//        let userCount = try modelContext.fetchCount(userDescriptor)
//        
//        // Only populate if we don't have any users yet
//        if userCount == 0 {
//            print("Creating sample data...")
//            
//            // Create sample data
//            try createSampleUsers()
//            try createSampleBloodRequests()
//            try createSampleDonationCenters()
//            
//            // Sync with Firebase
//            try await syncService.syncAll()
//            
//            print("Sample data created and synced to Firebase")
//        } else {
//            print("Sample data already exists. Skipping creation.")
//        }
//    }
//    
//    // MARK: - Private Methods
//    
//    private func createSampleUsers() throws {
//        // Create sample users
//        let user1 = UserModel(
//            id: UUID().uuidString,
//            email: "john@example.com",
//            name: "John Doe",
//            phoneNumber: "+353 87 123 4567",
//            bloodType: "A+",
//            lastDonationDate: Calendar.current.date(byAdding: .month, value: -2, to: Date()),
//            donationCount: 5,
//            country: "Ireland"
//        )
//        
//        let user2 = UserModel(
//            id: UUID().uuidString,
//            email: "jane@example.com",
//            name: "Jane Smith",
//            phoneNumber: "+353 87 765 4321",
//            bloodType: "O-",
//            lastDonationDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()),
//            donationCount: 8,
//            country: "Ireland"
//        )
//        
//        let user3 = UserModel(
//            id: UUID().uuidString,
//            email: "sam@example.com",
//            name: "Sam Wilson",
//            phoneNumber: "+353 86 555 1234",
//            bloodType: "B+",
//            lastDonationDate: nil,
//            donationCount: 0,
//            country: "Ireland"
//        )
//        
//        // Insert them into the database
//        modelContext.insert(user1)
//        modelContext.insert(user2)
//        modelContext.insert(user3)
//        
//        try modelContext.save()
//    }
//    
//    private func createSampleBloodRequests() throws {
//        // Create sample blood seekers
//        let request1 = BloodSeekerModel(
//            id: UUID().uuidString,
//            name: "Emergency at Dublin General",
//            seekerDescription: "Urgent need for A+ blood for surgery patient. Please help if you can donate today.",
//            location: "Dublin General Hospital, D02 X285",
//            bloodType: "A+",
//            imageURL: "blood_request_1",
//            userId: nil
//        )
//        
//        let request2 = BloodSeekerModel(
//            id: UUID().uuidString,
//            name: "Help needed for Maria",
//            seekerDescription: "Maria is 8 years old and needs O- blood for her ongoing treatment. Your donation could save her life.",
//            location: "Children's Hospital, Dublin",
//            bloodType: "O-",
//            imageURL: "blood_request_2",
//            userId: nil
//        )
//        
//        let request3 = BloodSeekerModel(
//            id: UUID().uuidString,
//            name: "Cancer Patient Needs Help",
//            seekerDescription: "B+ blood needed for cancer patient undergoing chemotherapy. Regular donations needed over the next few weeks.",
//            location: "St. James's Hospital, Dublin 8",
//            bloodType: "B+",
//            imageURL: "blood_request_3",
//            userId: nil
//        )
//        
//        // Insert them into the database
//        modelContext.insert(request1)
//        modelContext.insert(request2)
//        modelContext.insert(request3)
//        
//        try modelContext.save()
//    }
//    
//    private func createSampleDonationCenters() throws {
//        // Create sample donation centers
//        let center1 = DonationCenterModel(
//            id: UUID().uuidString,
//            name: "Irish Blood Transfusion Service - D'Olier Street",
//            address: "2-5 D'Olier Street",
//            city: "Dublin",
//            state: "Leinster",
//            zipCode: "D02 XY00",
//            phoneNumber: "+353 1 474 8100",
//            email: "info@ibts.ie",
//            website: "www.giveblood.ie",
//            latitude: 53.347402,
//            longitude: -6.257588
//        )
//        
//        let center2 = DonationCenterModel(
//            id: UUID().uuidString,
//            name: "St James's Hospital Blood Donation Clinic",
//            address: "James's Street",
//            city: "Dublin",
//            state: "Leinster",
//            zipCode: "D08 NHY1",
//            phoneNumber: "+353 1 416 2000",
//            email: "info@stjames.ie",
//            website: "www.stjames.ie",
//            latitude: 53.341598,
//            longitude: -6.291809
//        )
//        
//        // Add operating hours
//        let center1Monday = OperatingHoursModel(
//            day: Weekday.monday.rawValue,
//            openTime: "10:00",
//            closeTime: "19:30",
//            isClosed: false
//        )
//        
//        let center1Tuesday = OperatingHoursModel(
//            day: Weekday.tuesday.rawValue,
//            openTime: "10:00",
//            closeTime: "19:30",
//            isClosed: false
//        )
//        
//        let center1Wednesday = OperatingHoursModel(
//            day: Weekday.wednesday.rawValue,
//            openTime: "10:00",
//            closeTime: "19:30",
//            isClosed: false
//        )
//        
//        let center1Thursday = OperatingHoursModel(
//            day: Weekday.thursday.rawValue,
//            openTime: "10:00",
//            closeTime: "19:30",
//            isClosed: false
//        )
//        
//        let center1Friday = OperatingHoursModel(
//            day: Weekday.friday.rawValue,
//            openTime: "10:00",
//            closeTime: "19:30",
//            isClosed: false
//        )
//        
//        let center1Saturday = OperatingHoursModel(
//            day: Weekday.saturday.rawValue,
//            openTime: "10:00",
//            closeTime: "16:30",
//            isClosed: false
//        )
//        
//        let center1Sunday = OperatingHoursModel(
//            day: Weekday.sunday.rawValue,
//            openTime: "00:00",
//            closeTime: "00:00",
//            isClosed: true
//        )
//        
//        // Add operating hours to centers
//        center1.operatingHours = [
//            center1Monday,
//            center1Tuesday,
//            center1Wednesday,
//            center1Thursday,
//            center1Friday,
//            center1Saturday,
//            center1Sunday
//        ]
//        
//        // Set accepted blood types
//        center1.acceptedBloodTypes = [
//            BloodType.aPositive.rawValue,
//            BloodType.aNegative.rawValue,
//            BloodType.bPositive.rawValue,
//            BloodType.bNegative.rawValue,
//            BloodType.abPositive.rawValue,
//            BloodType.abNegative.rawValue,
//            BloodType.oPositive.rawValue,
//            BloodType.oNegative.rawValue
//        ]
//        
//        center2.acceptedBloodTypes = [
//            BloodType.aPositive.rawValue,
//            BloodType.aNegative.rawValue,
//            BloodType.oPositive.rawValue,
//            BloodType.oNegative.rawValue
//        ]
//        
//        // Current need levels
//        center1.currentNeedLevels = [
//            "A+: Medium",
//            "A-: High",
//            "B+: Low",
//            "B-: Medium",
//            "AB+: Low",
//            "AB-: High",
//            "O+: Medium",
//            "O-: Critical"
//        ]
//        
//        // Insert centers into the database
//        modelContext.insert(center1)
//        modelContext.insert(center2)
//        
//        try modelContext.save()
//    }
//} 


//
//  SampleDataService.swift
//  BloodConnect
//
//  Created by Sanidhya Pandey on 24/04/2025.
//

import Foundation
import SwiftData
import FirebaseFirestore

@MainActor
class SampleDataService {
    // MARK: - Properties
    private let modelContext: ModelContext
    private let syncService: FirebaseDataService

    // MARK: - Initialization
    init(modelContext: ModelContext? = nil) {
        if let modelContext = modelContext {
            self.modelContext = modelContext
        } else {
            self.modelContext = DatabaseManager.shared.mainContext
        }

        self.syncService = FirebaseDataService(modelContext: self.modelContext)
    }

    // MARK: - Public Methods

    /// Creates sample data for testing purposes
    func createSampleData() async throws {
        let userDescriptor = FetchDescriptor<UserModel>()
        let userCount = try modelContext.fetchCount(userDescriptor)

        if userCount == 0 {
            print("Creating sample data...")

            try createSampleUsers()
            try createSampleBloodRequests()
            try createSampleDonationCenters()

            try await syncService.syncAll()

            print("Sample data created and synced to Firebase")
        } else {
            print("Sample data already exists. Skipping creation.")
        }
    }

    // MARK: - Private Methods

    private func createSampleUsers() throws {
        let user1 = UserModel(
            id: UUID().uuidString,
            email: "john@example.com",
            name: "John Doe",
            phoneNumber: "+353 87 123 4567",
            bloodType: "A+",
            lastDonationDate: Calendar.current.date(byAdding: .month, value: -2, to: Date()),
            donationCount: 5,
            county: "Dublin",
            userType: "Donor",
    
            availability: "Weekends",
            address: "123 Donation St"
        )

        let user2 = UserModel(
            id: UUID().uuidString,
            email: "jane@example.com",
            name: "Jane Smith",
            phoneNumber: "+353 87 765 4321",
            bloodType: "O-",
            lastDonationDate: Calendar.current.date(byAdding: .day, value: -15, to: Date()),
            donationCount: 8,
            county: "Louth",
            userType: "Donor",
           
            availability: "Weekdays",
            address: "456 Lifeline Ave"
        )

        let user3 = UserModel(
            id: UUID().uuidString,
            email: "sam@example.com",
            name: "Sam Wilson",
            phoneNumber: "+353 86 555 1234",
            bloodType: "B+",
            lastDonationDate: nil,
            donationCount: 0,
            county: "Maynooth",
            userType: "Donor",
            
            availability: "Evenings",
            address: "789 Hope Blvd"
        )

        modelContext.insert(user1)
        modelContext.insert(user2)
        modelContext.insert(user3)

        try modelContext.save()
    }

    private func createSampleBloodRequests() throws {
        let request1 = BloodSeekerModel(
            id: UUID().uuidString,
            name: "Emergency at Dublin General",
            seekerDescription: "Urgent need for A+ blood for surgery patient. Please help if you can donate today.",
            location: "Dublin General Hospital, D02 X285",
            bloodType: "A+",
            imageURL: "blood_request_1",
            userId: nil
        )

        let request2 = BloodSeekerModel(
            id: UUID().uuidString,
            name: "Help needed for Maria",
            seekerDescription: "Maria is 8 years old and needs O- blood for her ongoing treatment. Your donation could save her life.",
            location: "Children's Hospital, Dublin",
            bloodType: "O-",
            imageURL: "blood_request_2",
            userId: nil
        )

        let request3 = BloodSeekerModel(
            id: UUID().uuidString,
            name: "Cancer Patient Needs Help",
            seekerDescription: "B+ blood needed for cancer patient undergoing chemotherapy. Regular donations needed over the next few weeks.",
            location: "St. James's Hospital, Dublin 8",
            bloodType: "B+",
            imageURL: "blood_request_3",
            userId: nil
        )

        modelContext.insert(request1)
        modelContext.insert(request2)
        modelContext.insert(request3)

        try modelContext.save()
    }

    private func createSampleDonationCenters() throws {
            // Create sample donation centers
            let center1 = DonationCenterModel(
                id: UUID().uuidString,
                name: "Irish Blood Transfusion Service - D'Olier Street",
                address: "2-5 D'Olier Street",
                city: "Dublin",
                state: "Leinster",
                zipCode: "D02 XY00",
                phoneNumber: "+353 1 474 8100",
                email: "info@ibts.ie",
                website: "www.giveblood.ie",
                latitude: 53.347402,
                longitude: -6.257588
            )
    
            let center2 = DonationCenterModel(
                id: UUID().uuidString,
                name: "St James's Hospital Blood Donation Clinic",
                address: "James's Street",
                city: "Dublin",
                state: "Leinster",
                zipCode: "D08 NHY1",
                phoneNumber: "+353 1 416 2000",
                email: "info@stjames.ie",
                website: "www.stjames.ie",
                latitude: 53.341598,
                longitude: -6.291809
            )
    
            // Add operating hours
            let center1Monday = OperatingHoursModel(
                day: Weekday.monday.rawValue,
                openTime: "10:00",
                closeTime: "19:30",
                isClosed: false
            )
    
            let center1Tuesday = OperatingHoursModel(
                day: Weekday.tuesday.rawValue,
                openTime: "10:00",
                closeTime: "19:30",
                isClosed: false
            )
    
            let center1Wednesday = OperatingHoursModel(
                day: Weekday.wednesday.rawValue,
                openTime: "10:00",
                closeTime: "19:30",
                isClosed: false
            )
    
            let center1Thursday = OperatingHoursModel(
                day: Weekday.thursday.rawValue,
                openTime: "10:00",
                closeTime: "19:30",
                isClosed: false
            )
    
            let center1Friday = OperatingHoursModel(
                day: Weekday.friday.rawValue,
                openTime: "10:00",
                closeTime: "19:30",
                isClosed: false
            )
    
            let center1Saturday = OperatingHoursModel(
                day: Weekday.saturday.rawValue,
                openTime: "10:00",
                closeTime: "16:30",
                isClosed: false
            )
    
            let center1Sunday = OperatingHoursModel(
                day: Weekday.sunday.rawValue,
                openTime: "00:00",
                closeTime: "00:00",
                isClosed: true
            )
    
            // Add operating hours to centers
            center1.operatingHours = [
                center1Monday,
                center1Tuesday,
                center1Wednesday,
                center1Thursday,
                center1Friday,
                center1Saturday,
                center1Sunday
            ]
    
            // Set accepted blood types
            center1.acceptedBloodTypes = [
                BloodType.aPositive.rawValue,
                BloodType.aNegative.rawValue,
                BloodType.bPositive.rawValue,
                BloodType.bNegative.rawValue,
                BloodType.abPositive.rawValue,
                BloodType.abNegative.rawValue,
                BloodType.oPositive.rawValue,
                BloodType.oNegative.rawValue
            ]
    
            center2.acceptedBloodTypes = [
                BloodType.aPositive.rawValue,
                BloodType.aNegative.rawValue,
                BloodType.oPositive.rawValue,
                BloodType.oNegative.rawValue
            ]
    
            // Current need levels
            center1.currentNeedLevels = [
                "A+: Medium",
                "A-: High",
                "B+: Low",
                "B-: Medium",
                "AB+: Low",
                "AB-: High",
                "O+: Medium",
                "O-: Critical"
            ]
    
            // Insert centers into the database
            modelContext.insert(center1)
            modelContext.insert(center2)
    
            try modelContext.save()
        }

}
