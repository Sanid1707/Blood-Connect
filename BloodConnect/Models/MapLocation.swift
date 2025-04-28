import Foundation
import MapKit

// Shared map annotation model for use across the app
struct MapLocation: Identifiable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let type: LocationType
    
    enum LocationType {
        case donor, organization
    }
} 