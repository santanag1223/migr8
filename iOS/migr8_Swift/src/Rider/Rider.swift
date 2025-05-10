import SwiftUI
import MapKit
import Observation

@Observable
class RiderData: Codable, Identifiable {
    var id: UUID = UUID()
    var avgRating: Float = 0
    var lifetimeMiles: Double = 0
    var prefs: PreferenceCollection = PreferenceCollection()
    var settings: RiderSettings = RiderSettings()
    
    enum CodingKeys: String, CodingKey {
        case avgRating, lifetimeMiles, offers, prefs, settings
    }
    
    init(id: UUID = UUID(),
         mileRate: Float = 0,
         hourRate: Float = 0,
         avgRating: Float = 0,
         lifetimeMiles: Double = 0,
         prefs: PreferenceCollection = PreferenceCollection(),
         settings: RiderSettings = RiderSettings())
    {
        self.id = id
        self.avgRating = avgRating
        self.lifetimeMiles = lifetimeMiles
        self.prefs = prefs
        self.settings = settings
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avgRating = try container.decode(Float.self, forKey: .avgRating)
        lifetimeMiles = try container.decode(Double.self, forKey: .lifetimeMiles)
        prefs = try container.decode(PreferenceCollection.self, forKey: .prefs)
        settings = try container.decode(RiderSettings.self, forKey: .settings)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avgRating, forKey: .avgRating)
        try container.encode(lifetimeMiles, forKey: .lifetimeMiles)
        try container.encode(prefs, forKey: .prefs)
        try container.encode(settings, forKey: .settings)
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
            
            RiderCommunityView(rider: rider)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Community")
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
