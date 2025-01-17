import SwiftUI
import MapKit

struct Region: Identifiable {
    let id = UUID()
    let name: String
    let surgeMultiplier: Double
}

struct PendingRider: Identifiable {
    let id: UUID
    let name: String
    let location: String
    let distance: Double
    let fareEstimate: Double
}

struct SurgePricingZone: Identifiable {
    let id: UUID
    let name: String
    let multiplier: Double
    let coordinate: CLLocationCoordinate2D
}

struct PendingRiderLocation: Identifiable {
    let id: UUID
    let name: String
    let coordinate: CLLocationCoordinate2D
}

enum DriverMapStatus {
    case driverOffline
    case pendingRider
    case rideActive
}

struct RateMapOverlay: View {
    @State private var highDemandAreas: [Region] = [
        Region(name: "Downtown", surgeMultiplier: 1.5),
        Region(name: "Airport", surgeMultiplier: 1.3)
    ]
    
    var body: some View {
        VStack {
            // Semi-transparent overlay card showing rate information
            VStack(alignment: .leading, spacing: 10) {
                Text("High Demand Areas")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ForEach(highDemandAreas) { region in
                    HStack {
                        Text(region.name)
                        Spacer()
                        Text("\(region.surgeMultiplier, specifier: "%.1f")x")
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
    @State private var pendingRiders: [PendingRider] = [
        PendingRider(id: UUID(), name: "John D.", location: "123 Main St", distance: 0.8, fareEstimate: 15.50),
        PendingRider(id: UUID(), name: "Sarah M.", location: "456 Oak Ave", distance: 1.2, fareEstimate: 22.75)
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

// Preview Provider for testing
struct MapOverlays_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray // Background for visibility in preview
            RateMapOverlay()
        }
        
        ZStack {
            Color.gray // Background for visibility in preview
            RiderMapOverlay()
        }
    }
}

struct DriverMapView: View {
    @ObservedObject var driver: Driver
    @ObservedObject var userState: UserState
    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ))
    @State private var mapStatus: DriverMapStatus = .driverOffline
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            Map(position: $camera).mapControls
            {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea()
            // User's location marker
            if let location = locationManager.userLocation {
                Marker("Your Location", coordinate: location)
                    .tint(driver.driverStatus == .online ? .green : .gray)
            }
            
            // Add markers based on mapStatus
            switch mapStatus {
            case .driverOffline:
                // Could add markers for ssurge pricing zones
                ForEach(getSurgePricingZones(), id: \.id) { zone in
                    Annotation(zone.name, coordinate: zone.coordinate) {
                        ZStack {
                            Circle()
                                .fill(.red.opacity(0.3))
                                .frame(width: 40, height: 40)
                            Text("\(zone.multiplier)x")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                
            case .pendingRider:
                // Add markers for potential riders
            case .rideActive:
                // Show route to destination
                if let route = getCurrentRoute() {
                    MapPolyline(route).stroke(.blue, lineWidth: 5)
                }
            }
            
        // Conditional overlays based on mapStatus
        if mapStatus == .driverOffline {
            RateMapOverlay()
        } else if mapStatus == .pendingRider {
            RiderMapOverlay()
        }
        }
    }
    
    // Helper functions to provide sample data
    private func getSurgePricingZones() -> [SurgePricingZone] {
        [
            SurgePricingZone(id: UUID(),
                            name: "Downtown",
                            multiplier: 1.5,
                            coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
            SurgePricingZone(id: UUID(),
                            name: "Airport",
                            multiplier: 1.3,
                            coordinate: CLLocationCoordinate2D(latitude: 37.7839, longitude: -122.4094))
        ]
    }
    
    private func getPendingRiders() -> [PendingRiderLocation] {
        [
            PendingRiderLocation(id: UUID(),
                               name: "John",
                               coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)),
            PendingRiderLocation(id: UUID(),
                               name: "Sarah",
                               coordinate: CLLocationCoordinate2D(latitude: 37.7839, longitude: -122.4094))
        ]
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
