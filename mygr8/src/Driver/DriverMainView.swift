import SwiftUI
import MapKit

enum DriverStatus {
    case online
    case offline
}

class Driver: ObservableObject {
    @Published var driverStatus: DriverStatus
    @Published var ratePerMile: Double
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var riderExtras: [RiderExtra]
    @Published var vehicles: [Vehicle]
    @Published var preferences: [String: Any]
    
    var minimumRate: Double
    var regionSurgeMultiplier: Double = 1.0
    
    init(ratePerMile: Double = 1.50, minimumRate: Double = 1.25) {
        self.driverStatus = .offline
        self.ratePerMile = ratePerMile
        self.minimumRate = minimumRate
        self.riderExtras = []
        self.vehicles = []
        self.preferences = [:]
    }
}

// View for display all DriverViews
struct DriverMainView: View {
    @State private var selectedTab = 0
    @ObservedObject var userState: UserState
    private var driver: Driver

    init(userState: UserState) {
        self.userState = userState
        self.driver = Driver()
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DriverMapView(driver: driver, userState: userState)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(0)
            
            DriverRateView(driver: driver, userState: userState)
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Rate")
                }
                .tag(1)
            
            DriverProfileView(driver: driver, userState: userState)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(2)
            
            if !userState.isLoggedIn {
                LoginView().environmentObject(userState)
            }
        }
    }
}
