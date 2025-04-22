import SwiftUI
import MapKit

/// Map Overlay should show prospetive riders with icons and prospecive
/// ride fare, if confirmed.
struct PendingRider: Identifiable {
    let id = UUID()
    let name: String
    let location: String
    let distance: Double
    let fareEstimate: Double
    let coordinate: CLLocationCoordinate2D
}

/// Map Overlay should support multiple `SurgePricingZones` that appear after
/// demand in a specified area is above a specific threshold.
struct SurgePricingZone: Identifiable {
    let id = UUID()
    let name: String
    let multiplier: Double
    let coordinate: CLLocationCoordinate2D
}

/// Driver's map states
enum DriverMapStatus {
    case driverOffline
    case pendingRider
    case rideActive
}

func GetSurgePricingZones() -> [SurgePricingZone] {
    return [
        SurgePricingZone(
            name: "Downtown",
            multiplier: 1.5,
            coordinate: CLLocationCoordinate2D(latitude: 37.774722, longitude: -122.418233)),
        SurgePricingZone(
            name: "Airport",
            multiplier: 1.3,
            coordinate: CLLocationCoordinate2D(latitude: 37.794722, longitude: -122.398233))
    ]
}

struct RateMapOverlay: View {
    @Environment(ModelData.self) var modelData
    @State private var highDemandAreas: [SurgePricingZone] = GetSurgePricingZones()
    
    var body: some View {
        // bindable for whenever modeldata contains updating rates
        
        VStack {
            // Semi-transparent overlay card showing rate information
            VStack(alignment: .leading, spacing: 10) {
                Text("High Demand Areas")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ForEach(highDemandAreas) { zone in
                    HStack {
                        Text(zone.name)
                        Spacer()
                        Text("\(zone.multiplier, specifier: "%.1f")x")
                            .foregroundColor(.yellow)
                    }
                    .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
    }
}

struct RiderMapOverlay: View {
    var driver: Driver
    
    // Logic for matching driver with new riders
    // along user preferences
    @State private var pendingRiders: [PendingRider] = [
        PendingRider(
            name: "John D.",
            location: "123 Main St",
            distance: 0.8,
            fareEstimate: 15.50,
            coordinate: CLLocationCoordinate2D(latitude: 34.5532445, longitude: -125.398233)),
        PendingRider(
            name: "Sarah M.",
            location: "456 Oak Ave",
            distance: 1.2,
            fareEstimate: 22.75,
            coordinate: CLLocationCoordinate2D(latitude: 35.396794, longitude: -121.695243))
    ]
    
    var body: some View {
        VStack {
            // Card showing available riders
            VStack(alignment: .leading, spacing: 10) {
                Text("Nearby Riders")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ForEach(pendingRiders) { rider in
                    Button(action: {
                        // Handle rider selection
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(rider.name)
                                    .fontWeight(.medium)
                                Text(rider.location)
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("$\(rider.fareEstimate, specifier: "%.2f")")
                                Text("\(rider.distance, specifier: "%.1f") mi")
                                    .font(.caption)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                    }
                    
                    if rider.id != pendingRiders.last?.id {
                        Divider()
                            .background(Color.gray)
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(10)
            .padding()
            
            Spacer()
        }
    }
}

struct DriverMapView: View {
    var driver: Driver
    @Environment(ModelData.self) var modelData
    
    @StateObject private var locationManager = LocationManager()
    @State private var mapStatus: DriverMapStatus = .driverOffline
    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    
    var body: some View {
        @Bindable var modelData = modelData
        
        ZStack {
            Map(position: $camera).mapControls
            {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            // User's location marker
                    
            // Add markers based on mapStatus
            switch mapStatus {
            case .driverOffline:
                // Could add markers for surge pricing zones
                RateMapOverlay()
            case .pendingRider:
                // Add markers for potential riders
                RiderMapOverlay(driver: driver)
            case .rideActive:
                // Show route to destination
                if let route = getCurrentRoute()
                {
                    // draw route
                }
            }
        }
    }
    
    private func getCurrentRoute() -> MKRoute? {
        // In a real app, this would return the actual route
        return nil
    }
}

// Location Manager to handle user location
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }
}

//// Preview Provider for testing
//struct MapOverlays_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.gray // Background for visibility in preview
//            RateMapOverlay()
//        }
//        
//        ZStack {
//            Color.gray // Background for visibility in preview
//            RiderMapOverlay(driver: .constant(Driver()))
//        }
//    }
//}
