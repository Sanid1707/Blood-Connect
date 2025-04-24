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
                Section("Users (\(users.count))") {
                    ForEach(users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text(user.email).font(.subheadline)
                            if let bloodType = user.bloodType {
                                Text("Blood Type: \(bloodType)")
                            }
                            if let country = user.country {
                                Text("Country: \(country)")
                            }
                            Text("Donations: \(user.donationCount)")
                        }
                    }
                }
                
                Section("Blood Requests (\(bloodSeekers.count))") {
                    ForEach(bloodSeekers) { seeker in
                        VStack(alignment: .leading) {
                            Text(seeker.name).font(.headline)
                            Text(seeker.requestDescription)
                            Text("Location: \(seeker.location)")
                            Text("Blood Type: \(seeker.bloodType)")
                            Text("Created: \(seeker.createdAt.formatted())")
                        }
                    }
                }
                
                Section("Donation Centers (\(donationCenters.count))") {
                    ForEach(donationCenters) { center in
                        VStack(alignment: .leading) {
                            Text(center.name).font(.headline)
                            Text("\(center.address), \(center.city)")
                            Text("Phone: \(center.phoneNumber)")
                            Text("Blood Types: \(center.acceptedBloodTypes.joined(separator: ", "))")
                        }
                    }
                }
                
                Section("Database Actions") {
                    Button("Reset Database") {
                        resetDatabase()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("SwiftData Debug")
        }
    }
    
    private func resetDatabase() {
        do {
            try DatabaseManager.shared.resetDatabase()
        } catch {
            print("Failed to reset database: \(error)")
        }
    }
}

#Preview {
    SwiftDataDebugView()
        .modelContainer(for: [UserModel.self, BloodSeekerModel.self, DonationCenterModel.self, OperatingHoursModel.self])
} 