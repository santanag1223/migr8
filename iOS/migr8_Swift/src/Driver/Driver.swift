import SwiftUI
import MapKit
import Observation

@Observable
class DriverData: Codable, Identifiable {
    var id: UUID = UUID()
    
    var mileRate: Double = 0
    var hourRate: Double = 0
    
    var avgRating: Float = 0
    var lifetimeMiles: Double = 0
    
    var vehicles: [Vehicle] = []
    var offers: OfferCollection = OfferCollection()
    var prefs: PreferenceCollection = PreferenceCollection()
    var settings: DriverSettings = DriverSettings()
    
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
    
    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data
        
        print("Bundle main path:", Bundle.main.bundlePath)
        print("Looking for file:", filename)
        print("Resource path:", Bundle.main.path(forResource: filename.components(separatedBy: ".")[0],
                                                 ofType: "json") ?? "not found")
        
        guard let file = Bundle.main.url(forResource: filename.components(separatedBy: ".")[0],
                                       withExtension: "json")
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }

    
    static func == (lhs: DriverData, rhs: DriverData) -> Bool {
        lhs.id == rhs.id
    }
}

@Observable
class Driver {
    var currentLocation: CLLocationCoordinate2D?
    var isAvailable: Bool = false
}

struct DriverMainView: View {
    @Environment(\.driverData) var driverData
    @State var driver: Driver = Driver()
    
    var body: some View {
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
