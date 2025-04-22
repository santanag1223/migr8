import SwiftUI
import MapKit

enum RiderMapStatus {
    case pendingDestination
    case pendingDriver
    case activeRide
}

struct RiderMapView: View {
    var rider: Rider
    @Environment(ModelData.self) var modelData
    @State var camera: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    ));
    @State private var mapStatus: RiderMapStatus = .pendingDestination;
    @StateObject private var locationManager = LocationManager();
    
    var body: some View {
        
        ZStack {
            Map(position: $camera)
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .ignoresSafeArea()
            // User's location marker
            
            switch mapStatus {
            case .pendingDestination:
                //
                VStack{}
            case .pendingDriver:
                //
                VStack{}
            case .activeRide:
                //
                VStack{}
            }
        }
    }
}
