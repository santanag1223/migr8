import SwiftUI
import MapKit
import Observation

@Observable
class RiderData: Codable, Identifiable {
    var id: UUID
    var prefs: PreferenceCollection = PreferenceCollection()
    
    init(id: UUID = UUID(),
        prefs: PreferenceCollection = PreferenceCollection())
    {
        self.id = id
        self.prefs = prefs
    }
    
    required init(from: Decoder) {
        self.id = UUID()
        self.prefs = PreferenceCollection()
    }
    
    func encode(to: Encoder) throws {
        
    }
    
    static func == (lhs: RiderData, rhs: RiderData) -> Bool {
        lhs.id == rhs.id
    }
}

@Observable
class Rider {
    var currentLocation: CLLocationCoordinate2D? = nil
    var isAvailable: Bool = false
}

struct RiderMainView: View {
    @State private var rider: Rider = Rider()

    var body: some View {
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

// Environment extentions
struct RiderDataKey: EnvironmentKey {
    static var defaultValue: RiderData = RiderData()
}

extension EnvironmentValues {
    var riderData: RiderData {
        get { self[RiderDataKey.self] }
        set { self[RiderDataKey.self] = newValue }
    }
}
