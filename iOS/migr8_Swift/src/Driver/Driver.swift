import SwiftUI
import MapKit

struct DriverData: Hashable, Identifiable, Codable {
    var id: Self { self }
    var offers: DriverOfferData = DriverOfferData()
    var prefs: PreferenceCollection = PreferenceCollection()
    var ratePerMile: Double = 0
    var vehicles: [Vehicle] = []
}

class Driver: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var isAvailable: Bool = false
    @Published var driverData: DriverData
        
    init(driverData: DriverData? = nil) {
        if let driverData = driverData {
            self.driverData = driverData
        } else {
            self.driverData = DriverData()
        }
    }
}

struct DriverMainView: View {
    @Environment(ModelData.self) var modelData
    @State var driver: Driver
    
    init(driverData: DriverData?) {
        driver = Driver(driverData: driverData)
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        
        TabView() {
            DriverMapView(driver: driver)
                .tabItem {
                    Image(systemName: "map")
                    Text("Drive")
                }
            
            DriverRateView(driver: driver)
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Rate")
                }
            
            DriverProfileView(driver: driver)
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
        }
    }
}
