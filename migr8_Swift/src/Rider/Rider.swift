import SwiftUI
import MapKit


enum RideStatus {
    case pendingDestination
    case pendingDriver
    case activeRide
}

struct RiderData: Hashable, Identifiable, Codable {
    var id: Self { self }
    var prefs: PreferenceCollection = PreferenceCollection()
}

class Rider: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D? = nil
    @Published var isAvailable: Bool = false
    @Published var riderData: RiderData
        
    init(riderData: RiderData? = nil) {
        if let riderData = riderData {
            self.riderData = riderData
        }
        else {
            self.riderData = RiderData()
        }
    }
}

struct RiderMainView: View {
    @Environment(ModelData.self) var modelData
    @State private var rider: Rider
    
    init(riderData: RiderData? = nil) {
        rider = Rider(riderData: riderData)
    }
    
    var body: some View {
        @Bindable var modelData = modelData

        TabView() {
            RiderMapView(rider: rider)
                .tabItem {
                    Image(systemName: "map")
                    Text("Ride")
                }
            
            RiderOrderView(rider: rider)
                .tabItem {
                    Image(systemName: "cart.circle")
                    Text("Order")
                }
            
            RiderProfileView(rider: rider)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}
