import SwiftUI
import CoreLocation
import Combine

struct PostBloodRequestView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var patientName = ""
    @State private var selectedBloodType: String = "B+"
    @State private var bloodUnit: Double = 2
    @State private var mobileNumber = ""
    @State private var selectedLocation = ""
    @State private var gender = ""
    @State private var searchRadius: Double = 10.0 // in kilometers
    @State private var birthDate = Date()
    @State private var isUrgent = false
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showLocationError = false
    
    private let bloodRequestService = BloodRequestService()
    private let locationManager = LocationManager()
    
    // Add user information
    @EnvironmentObject var authViewModel: AuthViewModel
    private let userService = UserService()
    
    let bloodGroups = ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"]
    let genders = ["Male", "Female", "Other"]
    let locations = ["Cork", "Dundalk", "Dublin", "Maynooth"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Post A Request")
                        .font(.headline)
                    Spacer()
                    Spacer().frame(width: 24) // spacer to balance the back arrow
                }

                // Patient Name
                VStack(alignment: .leading, spacing: 10) {
                    Text("Select Patient Name")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    TextField("Patient Name", text: $patientName)
                        .padding(.horizontal,40)
                        .padding(.vertical,15)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            HStack {
                                Image(systemName: "person")
                                Spacer()
                            }
                            .padding(.horizontal, 10)
                            .foregroundColor(.gray)
                        )
                }

                // Blood Group
                Text("Select Blood Group")
                    .fontWeight(.semibold)
                    .font(.subheadline)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4), spacing: 12) {
                    ForEach(bloodGroups, id: \.self) { group in
                        Button(action: {
                            selectedBloodType = group
                        }) {
                            Text(group)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedBloodType == group ? AppColor.primaryRed.opacity(0.2) : Color(UIColor.systemGray5))
                                .foregroundColor(.black)
                                .cornerRadius(50)
                                .overlay(
                                    Circle()
                                        .stroke(selectedBloodType == group ? AppColor.primaryRed: Color.clear, lineWidth: 2)
                                )
                        }
                    }
                }

                // Blood Unit
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Blood Unit")
                        .fontWeight(.semibold)
                    Slider(value: $bloodUnit, in: 1...10, step: 1)
                        .accentColor(Color(red: 230/255, green: 4/255, blue: 73/255))
                    Text("\(Int(bloodUnit)) Unit")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                // Mobile Number
                VStack(alignment: .leading, spacing: 8) {
                    Text("Enter Mobile Number")
                        .fontWeight(.semibold)
                        .padding(.vertical,15)
                    TextField("Mobile Number", text: $mobileNumber)
                        .keyboardType(.phonePad)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }

                // Search Radius
                VStack(alignment: .leading, spacing: 8) {
                    Text("Search Radius (km)")
                        .fontWeight(.semibold)
                    Slider(value: $searchRadius, in: 1...50, step: 1)
                        .accentColor(Color(red: 230/255, green: 4/255, blue: 73/255))
                    Text("\(Int(searchRadius)) km")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Urgent toggle
                Toggle(isOn: $isUrgent) {
                    Text("Urgent Request")
                        .fontWeight(.semibold)
                }
                .toggleStyle(SwitchToggleStyle(tint: AppColor.primaryRed))
                .padding(.vertical, 8)

                // Gender and Date
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        Text("Gender")
                            .fontWeight(.semibold)
                        Picker("Gender", selection: $gender) {
                            Text("Gender").tag("")
                            ForEach(genders, id: \.self) { g in
                                Text(g).tag(g)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.vertical,10)
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    }

                    VStack(alignment: .leading) {
                        Text("Date")
                            .fontWeight(.semibold)
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical,10)
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                    }
                }

                // Send Request Button
                Button(action: {
                    submitBloodRequest()
                }) {
                    if isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Send Request")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(isSubmitting ? AppColor.primaryRed.opacity(0.7) : AppColor.primaryRed)
                .cornerRadius(12)
                .disabled(isSubmitting || !isFormValid)
                .opacity(isFormValid ? 1.0 : 0.6)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(alertTitle),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertTitle == "Success" {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
        }
        .onAppear {
            // Request location permission when the view appears
            locationManager.requestLocationPermission()
        }
    }
    
    private var isFormValid: Bool {
        !patientName.isEmpty && 
        !selectedBloodType.isEmpty && 
        Int(bloodUnit) > 0 && 
        !mobileNumber.isEmpty && 
        !gender.isEmpty
    }
    
    private func submitBloodRequest() {
        isSubmitting = true
        
        // Get current user information
        guard let currentUser = getCurrentUser() else {
            showError(title: "Authentication Error", message: "Please log in to submit a blood request")
            isSubmitting = false
            return
        }
        
        // Get current location
        guard let userLocation = locationManager.location else {
            showLocationError = true
            showError(title: "Location Error", message: "We couldn't determine your current location. Please enable location services and try again.")
            isSubmitting = false
            return
        }
        
        // Create blood request object
        let bloodRequest = BloodRequest(
            patientName: patientName,
            bloodGroup: selectedBloodType,
            unitsRequired: Int(bloodUnit),
            mobileNumber: mobileNumber,
            gender: gender,
            requestDate: birthDate,
            requestorName: currentUser.name,
            searchRadius: searchRadius,
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude,
            isUrgent: isUrgent
        )
        
        // Set the requestorId separately 
        var requestWithId = bloodRequest
        requestWithId.requestorId = currentUser.id
        
        // Save the blood request to the database
        Task {
            do {
                _ = try await bloodRequestService.createBloodRequest(requestWithId).async()
                DispatchQueue.main.async {
                    isSubmitting = false
                    alertTitle = "Success"
                    alertMessage = "Your blood request has been submitted successfully. Eligible donors will be notified."
                    showAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    isSubmitting = false
                    showError(title: "Error", message: "Failed to submit blood request: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func showError(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    private func getCurrentUser() -> User? {
        // In a real app, you would get the current user from authentication
        let users = userService.getAllUsers()
        return users.first // For testing purposes
    }
}

// Location Manager to get user's current location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

extension Publisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = self.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                },
                receiveValue: { value in
                    continuation.resume(returning: value)
                    cancellable?.cancel()
                }
            )
        }
    }
}

#Preview {
    PostBloodRequestView()
}
