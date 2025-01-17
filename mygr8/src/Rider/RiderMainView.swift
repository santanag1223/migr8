import SwiftUI
import MapKit

enum RiderStatus {
    case pendingDestination
    case pendingDriver
    case activeRide
}

class Rider: ObservableObject {
    @Published var riderStatus: RiderStatus
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var preferences: [String: Any]
    
    
    init(ratePerMile: Double = 1.50, minimumRate: Double = 1.25) {
        self.preferences = [:]
    }
}

struct RiderMainView: View {
    @State private var selectedTab = 0
    @ObservedObject var userState: UserState
    private var rider: Rider
    
    init(userState: UserState) {
        self.userState = userState
        self.rider = Rider()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RiderMapView(rider: rider, userState: userState)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(0)
            
            RiderOrderView(rider: rider, userState: userState)
                .tabItem {
                    Image(systemName: "cart.circle")
                    Text("Order")
                }
                .tag(1)
            
            RiderProfileView(rider: rider, userState: userState)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}

