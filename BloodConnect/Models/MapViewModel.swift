import Foundation
import MapKit
import CoreLocation
import SwiftUI

@MainActor
class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var donationCenters: [DonationCenter] = []
    @Published var selectedCenter: DonationCenter? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    private var locationManager: CLLocationManager?
    private var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAccess() {
        isLoading = true
        locationManager?.requestWhenInUseAuthorization()
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            isLoading = false
            errorMessage = "Location access denied. Please enable it in settings to find nearby donation centers."
            showError = true
        case .notDetermined:
            // Wait for the user's decision
            break
        @unknown default:
            isLoading = false
            errorMessage = "Unknown location authorization status."
            showError = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        userLocation = location.coordinate
        
        // Stop updating location to save battery
        locationManager?.stopUpdatingLocation()
        
        // Load donation centers with updated location
        loadDonationCenters()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isLoading = false
        errorMessage = "Failed to get your location: \(error.localizedDescription)"
        showError = true
    }
    
    // MARK: - Data Loading
    
    private func loadDonationCenters() {
        // In a real app, this would fetch data from a server/API
        // For this sample, we're creating mock data
        
        guard let userLocation = userLocation else {
            isLoading = false
            errorMessage = "Unable to determine your location."
            showError = true
            return
        }
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let centersWithDistance = self.createSampleDonationCenters(near: userLocation)
                .map { $0.withDistance(from: userLocation) }
            
            // Sort centers by distance with proper type annotation for closure
            self.donationCenters = centersWithDistance.sorted { (a, b) -> Bool in
                guard let distanceA = a.distance, let distanceB = b.distance else {
                    return false // Handle case where distance is nil
                }
                return distanceA < distanceB
            }
            
            self.isLoading = false
            
            // Update selected center if one was previously selected
            if let selected = self.selectedCenter, let updatedCenter = self.donationCenters.first(where: { $0.id == selected.id }) {
                self.selectedCenter = updatedCenter
            }
        }
    }
    
    private func createSampleDonationCenters(near location: CLLocationCoordinate2D) -> [DonationCenter] {
        // Create sample donation centers around the user's location
        
        // Small offsets to create centers around the user's location
        let offsets: [(lat: Double, lng: Double, name: String, address: String)] = [
            (0.01, 0.01, "City Blood Bank", "123 Main Street"),
            (-0.008, 0.015, "University Hospital", "45 Medical Drive"),
            (0.015, -0.01, "Community Donation Center", "78 Community Road"),
            (-0.02, -0.018, "Regional Medical Center", "950 Health Avenue"),
            (0.005, 0.025, "Downtown Blood Clinic", "15 Central Plaza")
        ]
        
        return offsets.enumerated().map { index, offset in
            // Create coordinates
            let centerCoordinate = CLLocationCoordinate2D(
                latitude: location.latitude + offset.lat,
                longitude: location.longitude + offset.lng
            )
            
            // Create default operating hours for weekdays
            let operatingHours: [OperatingHours] = Weekday.allCases.map { day in
                let isClosed = day == .sunday || day == .saturday
                return OperatingHours(
                    day: day,
                    openTime: "9:00 AM",
                    closeTime: "5:00 PM",
                    isClosed: isClosed
                )
            }
            
            // Create a sample DonationCenter using the factory method
            return DonationCenter.forMapView(
                id: "center_\(index + 1)",
                name: offset.name,
                address: offset.address,
                phoneNumber: "+353 \(Int.random(in: 100...999)) \(Int.random(in: 1000...9999))",
                coordinate: centerCoordinate,
                operatingHours: operatingHours
            )
        }
    }
    
    // MARK: - User Actions
    
    func selectCenter(_ center: DonationCenter) {
        selectedCenter = center
    }
    
    func callCenter(_ center: DonationCenter) {
        guard let url = URL(string: "tel://\(center.phoneNumber.replacingOccurrences(of: " ", with: ""))") else {
            errorMessage = "Could not make the call."
            showError = true
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            errorMessage = "Your device cannot make phone calls."
            showError = true
        }
    }
    
    func getDirections(to center: DonationCenter) {
        let placemark = MKPlacemark(coordinate: center.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = center.name
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
} 