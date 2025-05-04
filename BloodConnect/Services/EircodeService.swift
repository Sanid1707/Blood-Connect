import Foundation
import Combine
import CoreLocation

class EircodeService {
    static let shared = EircodeService()
    
    private let geocoder = CLGeocoder()
    
    // Validate Eircode format (basic validation)
    func isValidEircode(_ eircode: String) -> Bool {
        // Basic Eircode format: A65 F4E2 (3 characters, space, 4 characters)
        let pattern = "^[A-Za-z0-9]{3}\\s?[A-Za-z0-9]{4}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: eircode.count)
        return regex?.firstMatch(in: eircode, range: range) != nil
    }
    
    // Geocode an Eircode to get address and coordinates
    func geocodeEircode(_ eircode: String) -> AnyPublisher<(address: String, coordinates: CLLocationCoordinate2D), Error> {
        return Future<(address: String, coordinates: CLLocationCoordinate2D), Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError(domain: "EircodeService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Service unavailable"])))
                return
            }
            
            // Format the search string to focus on Ireland
            let searchString = "\(eircode), Ireland"
            
            self.geocoder.geocodeAddressString(searchString) { placemarks, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let placemark = placemarks?.first,
                      let location = placemark.location?.coordinate else {
                    promise(.failure(NSError(domain: "EircodeService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find location for this Eircode"])))
                    return
                }
                
                // Build address string
                var addressComponents: [String] = []
                
                if let thoroughfare = placemark.thoroughfare {
                    addressComponents.append(thoroughfare)
                }
                
                if let subThoroughfare = placemark.subThoroughfare {
                    // If there's a street number, add it before the street name
                    if let index = addressComponents.firstIndex(where: { $0 == placemark.thoroughfare }) {
                        addressComponents.insert(subThoroughfare, at: index)
                    } else {
                        addressComponents.append(subThoroughfare)
                    }
                }
                
                if let locality = placemark.locality {
                    addressComponents.append(locality)
                }
                
                if let subLocality = placemark.subLocality {
                    addressComponents.append(subLocality)
                }
                
                if let administrativeArea = placemark.administrativeArea {
                    addressComponents.append(administrativeArea)
                }
                
                // Add the Eircode
                addressComponents.append(eircode)
                
                let address = addressComponents.joined(separator: ", ")
                
                promise(.success((address: address, coordinates: location)))
            }
        }
        .eraseToAnyPublisher()
    }
} 