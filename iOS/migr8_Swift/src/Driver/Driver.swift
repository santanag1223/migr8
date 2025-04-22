import SwiftUI
import MapKit
import Observation

@Observable
class DriverData: Codable, Identifiable {
    var id: UUID
    var mileRate: Double
    var hourRate: Double
    var vehicles: [Vehicle]
    var offers: OfferCollection
    var prefs: PreferenceCollection
    
    init(id: UUID = UUID(),
         mileRate: Double = 0,
         hourRate: Double = 0,
         vehicles: [Vehicle] = [],
         offers: OfferCollection = OfferCollection(),
         prefs: PreferenceCollection = PreferenceCollection())
    {
        self.id = id
        self.mileRate = mileRate
        self.hourRate = hourRate
        self.vehicles = vehicles
        self.offers = offers
        self.prefs = prefs
    }
    
    required init(from: Decoder) {
        self.id = UUID()
        self.hourRate = 0
        self.mileRate = 0
        self.vehicles = []
        self.offers = OfferCollection()
        self.prefs = PreferenceCollection()
    }
    
    func encode(to: Encoder) throws {
        
    }
    
    static func == (lhs: DriverData, rhs: DriverData) -> Bool {
        lhs.id == rhs.id
    }
}

@Observable
class Driver {
    var currentLocation: CLLocationCoordinate2D?
    var isAvailable: Bool = false
    var driverData: DriverData
        
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
    
    init(driverData: DriverData? = nil) {
        driver = Driver(driverData: driverData)
    }
    
    var body: some View {
        @Bindable var modelData = modelData
        
        TabView() {
            DriverMapView(driver: driver)
                .tabItem {
                    Image(systemName: "car.side")
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

// Environment extentions
struct DriverDataKey: EnvironmentKey {
    static var defaultValue: DriverData = DriverData()
}

extension EnvironmentValues {
    var driverData: DriverData {
        get { self[DriverDataKey.self] }
        set { self[DriverDataKey.self] = newValue }
    }
}
