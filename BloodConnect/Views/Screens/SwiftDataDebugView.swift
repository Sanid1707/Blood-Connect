//import SwiftUI
//import SwiftData
//
//struct SwiftDataDebugView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var users: [UserModel]
//    @Query private var bloodSeekers: [BloodSeekerModel]
//    @Query private var donationCenters: [DonationCenterModel]
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                Section("Users (\(users.count))") {
//                    ForEach(users) { user in
//                        VStack(alignment: .leading) {
//                            Text(user.name).font(.headline)
//                            Text(user.email).font(.subheadline)
//                            if let bloodType = user.bloodType {
//                                Text("Blood Type: \(bloodType)")
//                            }
//                            if let county = user.county {
//                                Text("County: \(county)")
//                            }
//                            Text("Donations: \(user.donationCount)")
//                        }
//                    }
//                }
//                
//                Section("Blood Requests (\(bloodSeekers.count))") {
//                    ForEach(bloodSeekers) { seeker in
//                        VStack(alignment: .leading) {
//                            Text(seeker.name).font(.headline)
//                            Text(seeker.requestDescription)
//                            Text("Location: \(seeker.location)")
//                            Text("Blood Type: \(seeker.bloodType)")
//                            Text("Created: \(seeker.createdAt.formatted())")
//                        }
//                    }
//                }
//                
//                Section("Donation Centers (\(donationCenters.count))") {
//                    ForEach(donationCenters) { center in
//                        VStack(alignment: .leading) {
//                            Text(center.name).font(.headline)
//                            Text("\(center.address), \(center.city)")
//                            Text("Phone: \(center.phoneNumber)")
//                            Text("Blood Types: \(center.acceptedBloodTypes.joined(separator: ", "))")
//                        }
//                    }
//                }
//                
//                Section("Database Actions") {
//                    Button("Reset Database") {
//                        resetDatabase()
//                    }
//                    .foregroundColor(.red)
//                }
//            }
//            .navigationTitle("SwiftData Debug")
//        }
//    }
//    
//    private func resetDatabase() {
//        do {
//            try DatabaseManager.shared.resetDatabase()
//        } catch {
//            print("Failed to reset database: \(error)")
//        }
//    }
//}
//
//#Preview {
//    SwiftDataDebugView()
//        .modelContainer(for: [UserModel.self, BloodSeekerModel.self, DonationCenterModel.self, OperatingHoursModel.self])
//} 


import SwiftUI
import SwiftData

struct SwiftDataDebugView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserModel]
    @Query private var bloodSeekers: [BloodSeekerModel]
    @Query private var donationCenters: [DonationCenterModel]
    
    var body: some View {
        NavigationStack {
            List {
                userSection
                bloodRequestSection
                donationCenterSection
                actionSection
            }
            .navigationTitle("SwiftData Debug")
        }
    }

    private var userSection: some View {
        Section("Users (\(users.count))") {
            ForEach(users) { user in
                userView(user)
            }
        }
    }

    private var bloodRequestSection: some View {
        Section("Blood Requests (\(bloodSeekers.count))") {
            ForEach(bloodSeekers) { seeker in
                bloodSeekerView(seeker)
            }
        }
    }

    private var donationCenterSection: some View {
        Section("Donation Centers (\(donationCenters.count))") {
            ForEach(donationCenters) { center in
                donationCenterView(center)
            }
        }
    }

    private var actionSection: some View {
        Section("Database Actions") {
            Button("Generate Sample Data") {
                generateSampleData()
            }
            .foregroundColor(.blue)
            
            Button("Reset Database", role: .destructive) {
                resetDatabase()
            }
        }
    }

    private func userView(_ user: UserModel) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(user.name).font(.headline)
            Text(user.email).font(.subheadline)
            
            Text("User Type: \(user.userType)")
            
            if let bloodType = user.bloodType {
                Text("Blood Type: \(bloodType)")
            }
            
            if let county = user.county {
                Text("County: \(county)")
            }
            
            if let eircode = user.eircode {
                Text("Eircode: \(eircode)")
            }
            
            if let address = user.address, !address.isEmpty {
                Text("Address: \(address)")
            }
            
            if let lat = user.latitude, let lon = user.longitude {
                Text("Location: \(String(format: "%.6f", lat)), \(String(format: "%.6f", lon))")
            }
            
            if let phone = user.phoneNumber {
                Text("Phone: \(phone)")
            }
            
            if user.userType == "organization" {
                if let orgDesc = user.organizationDescription {
                    Text("Description: \(orgDesc)")
                }
                
                if let workingHours = user.workingHours {
                    Text("Hours: \(workingHours)")
                }
            } else {
                if let availability = user.availability {
                    Text("Availability: \(availability)")
                }
                Text("Donations: \(user.donationCount)")
                if let lastDonation = user.lastDonationDate {
                    Text("Last Donation: \(lastDonation.formatted(date: .abbreviated, time: .omitted))")
                }
            }
            
            Text("Created: \(user.createdAt.formatted(date: .abbreviated, time: .shortened))")
        }
        .padding(.vertical, 4)
    }

    private func bloodSeekerView(_ seeker: BloodSeekerModel) -> some View {
        VStack(alignment: .leading) {
            Text(seeker.name).font(.headline)
            Text(seeker.seekerDescription)
            Text("Location: \(seeker.location)")
            Text("Blood Type: \(seeker.bloodType)")
            Text("Created: \(seeker.createdAt.formatted())")
        }
    }

    private func donationCenterView(_ center: DonationCenterModel) -> some View {
        VStack(alignment: .leading) {
            Text(center.name).font(.headline)
            Text("\(center.address), \(center.city)")
            Text("Phone: \(center.phoneNumber)")
            Text("Blood Types: \(center.acceptedBloodTypes.joined(separator: ", "))")
        }
    }

    private func resetDatabase() {
        do {
            try DatabaseManager.shared.resetDatabase()
        } catch {
            print("Failed to reset database: \(error)")
        }
    }

    private func generateSampleData() {
        // Sample users with addresses and eircodes
        let users = [
            UserModel(
                email: "donor@example.com",
                name: "John Donor",
                phoneNumber: "+353 87 123 4567",
                bloodType: "O+",
                donationCount: 3,
                county: "Dublin",
                userType: "donor",
                availability: "Weekends and Evenings",
                address: "123 Main Street, Dublin 1, D01 AB12",
                latitude: 53.349805,
                longitude: -6.260310,
                eircode: "D01 F5P2"
            ),
            UserModel(
                email: "hospital@example.com",
                name: "City Hospital",
                phoneNumber: "+353 1 234 5678",
                bloodType: nil,
                donationCount: 0,
                county: "Dublin",
                userType: "organization",
                availability: nil,
                address: "St. Stephen's Green, Dublin 2, D02 XY31",
                latitude: 53.339428,
                longitude: -6.261924,
                organizationDescription: "Major teaching hospital serving the Dublin area",
                workingHours: "24/7",
                eircode: "D02 XY31"
            ),
            UserModel(
                email: "clinic@example.com",
                name: "Cork Blood Clinic",
                phoneNumber: "+353 21 123 4567",
                bloodType: nil,
                donationCount: 0,
                county: "Cork",
                userType: "organization",
                availability: nil,
                address: "10 Patrick Street, Cork City, Cork",
                latitude: 51.898520,
                longitude: -8.475100,
                organizationDescription: "Specialized blood donation center",
                workingHours: "Mon-Fri: 9AM-5PM, Sat: 10AM-2PM",
                eircode: "T12 RW7E"
            )
        ]
        
        // Insert all users
        for user in users {
            modelContext.insert(user)
        }
        
        // Sample blood seekers
        let seekers = [
            BloodSeekerModel(
                name: "Emergency Room",
                seekerDescription: "Urgent need for O- blood for multiple trauma patients",
                location: "Dublin",
                bloodType: "O-",
                imageURL: "https://example.com/hospital.jpg",
                userId: users[1].id
            ),
            BloodSeekerModel(
                name: "Children's Hospital",
                seekerDescription: "Need AB+ blood for scheduled surgeries tomorrow",
                location: "Cork",
                bloodType: "AB+",
                imageURL: "https://example.com/childrens.jpg",
                userId: users[2].id
            )
        ]
        
        // Insert all blood seekers
        for seeker in seekers {
            modelContext.insert(seeker)
        }
        
        // Save changes
        do {
            try modelContext.save()
        } catch {
            print("Error generating sample data: \(error)")
        }
    }
}

#Preview {
    SwiftDataDebugView()
        .modelContainer(for: [
            UserModel.self,
            BloodSeekerModel.self,
            DonationCenterModel.self,
            OperatingHoursModel.self
        ])
}
