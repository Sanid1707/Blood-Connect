import SwiftUI

struct BloodRequestsListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var bloodRequests: [BloodRequest] = []
    @State private var isLoading = true
    private let bloodRequestService = BloodRequestService()
    
    var body: some View {
        VStack {
            TopBarView(
                title: "Blood Requests",
                showBackButton: true,
                onBackTapped: {
                    presentationMode.wrappedValue.dismiss()
                },
                onSettingsTapped: {
                    // Handle settings action
                }
            )
            
            if isLoading {
                Spacer()
                ProgressView("Loading blood requests...")
                Spacer()
            } else if bloodRequests.isEmpty {
                Spacer()
                Text("No blood requests found")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List(bloodRequests, id: \.id) { request in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(request.patientName)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text(request.bloodGroup)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(AppColor.primaryRed)
                                .cornerRadius(12)
                        }
                        
                        Text("Needs \(request.unitsRequired) units • \(request.gender)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Contact: \(request.mobileNumber)")
                            .font(.subheadline)
                        
                        HStack {
                            Text("Created by \(request.requestorName)")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(formattedDate(request.requestDate))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        if request.isUrgent {
                            Text("URGENT")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Color.red)
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            loadBloodRequests()
        }
    }
    
    private func loadBloodRequests() {
        isLoading = true
        
        // Use the blood request service to get all blood requests
        DispatchQueue.main.async {
            self.bloodRequests = self.bloodRequestService.getAllBloodRequests()
            self.isLoading = false
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    BloodRequestsListView()
} 