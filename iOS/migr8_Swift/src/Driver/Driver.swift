import SwiftUI
import MapKit
import Observation

@Observable
class DriverData: Codable, Identifiable {
    var id: UUID
    
    var mileRate: Double
    var hourRate: Double
    
    var avgRating: Float
    var lifetimeMiles: Double
    
    var vehicles: [Vehicle]
    var offers: OfferCollection
    var prefs: PreferenceCollection
    var settings: DriverSettings
    
    init(id: UUID = UUID(),
         mileRate: Double = 0,
         hourRate: Double = 0,
         avgRating: Float = 0,
         lifetimeMiles: Double = 0,
         vehicles: [Vehicle] = [],
         offers: OfferCollection = OfferCollection(),
         prefs: PreferenceCollection = PreferenceCollection(),
         settings: DriverSettings = DriverSettings())
    {
        self.id = id
        self.mileRate = mileRate
        self.hourRate = hourRate
        self.avgRating = avgRating
        self.lifetimeMiles = lifetimeMiles
        self.vehicles = vehicles
        self.offers = offers
        self.prefs = prefs
        self.settings = settings
    }
    
    required init(from: Decoder) {
        self.id = UUID()
        self.hourRate = 0
        self.mileRate = 0
        self.avgRating = 0
        self.lifetimeMiles = 0
        self.vehicles = []
        self.offers = OfferCollection()
        self.prefs = PreferenceCollection()
        self.settings = DriverSettings()
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
