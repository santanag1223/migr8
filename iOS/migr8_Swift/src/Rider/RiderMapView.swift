import SwiftUI
import MapKit

enum RiderMapStatus {
    case pendingDestination
    case pendingDriver
    case activeRide
}

struct RiderMapView: View {
    var rider: Rider
    
    @State var camera: MapCameraPosition = .automatic
    @State private var mapStatus: RiderMapStatus = .pendingDestination
    
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
