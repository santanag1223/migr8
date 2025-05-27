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
    var offers: [Offer] = DEFAULT_OFFERS
    var prefs: PreferenceCollection = PreferenceCollection()
    var settings: DriverSettings = DriverSettings()
    
    enum CodingKeys: String, CodingKey {
        case mileRate, hourRate, avgRating, lifetimeMiles,
             vehicles, offers, prefs, settings
    }
    
    init(id: UUID = UUID(),
         mileRate: Double = 0,
         hourRate: Double = 0,
         avgRating: Float = 0,
         lifetimeMiles: Double = 0,
         vehicles: [Vehicle] = [],
         offers: [Offer] = DEFAULT_OFFERS,
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        avgRating = try container.decode(Float.self, forKey: .avgRating)
        lifetimeMiles = try container.decode(Double.self, forKey: .lifetimeMiles)
        prefs = try container.decode(PreferenceCollection.self, forKey: .prefs)
        settings = try container.decode(DriverSettings.self, forKey: .settings)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(avgRating, forKey: .avgRating)
        try container.encode(lifetimeMiles, forKey: .lifetimeMiles)
        try container.encode(offers, forKey: .offers)
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
    
    static func == (lhs: DriverData, rhs: DriverData) -> Bool {
        lhs.id == rhs.id
    }
}

@Observable
class DriverStatus: Codable, Identifiable {
    var id: UUID = UUID()
    
    var isEditing: Bool = false

    var isOnline: Bool = false
    var ridesAvaliable: Bool = false
    var ordersAvailable: Bool = false
    var extrasAvailable: Bool = false
        
    init(id: UUID = UUID(),
         isEditing: Bool = false,
         isOnline: Bool = false,
         ridesAvaliable: Bool = false,
         ordersAvailable: Bool = false,
         extrasAvailable: Bool = false)
    {
        self.id = id
        self.isEditing = isEditing
        self.isOnline = isOnline
        self.ridesAvaliable = ridesAvaliable
        self.ordersAvailable = ordersAvailable
        self.extrasAvailable = extrasAvailable
    }
    
    func StatusString() -> String {
        var string: String = ""
        
        if (self.ridesAvaliable) {
            string += "( Rides"
        }
        
        if (self.ordersAvailable) {
            if (!string.isEmpty) {
                string += ", "
            } else {
                string += "( "
            }
            
            string += "Orders"
        }
        
        if (self.extrasAvailable) {
            if (!string.isEmpty) {
                string += ", "
            } else {
                string += "( "
            }
            
            string += "Extras"
        }
        
        if (!string.isEmpty) {
            string += " )"
        }
        
        return string
    }
    
    static func == (lhs: DriverStatus, rhs: DriverStatus) -> Bool {
        lhs.id == rhs.id
    }
    
    static func StatusView(driverStatus: DriverStatus) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if (driverStatus.isOnline) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .foregroundColor(.green)
                
                Spacer()

                
                Text("Online")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                
                Text(driverStatus.StatusString())
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            else {
                Image(systemName: "person.crop.circle.badge.xmark")
                    .foregroundColor(.indigo)
                
                Spacer()
                
                Text("Offline")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button(action: { driverStatus.isEditing.toggle() }) {
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
        }
    }
    
    static func StatusEditor(driverStatus: Binding<DriverStatus>) -> some View {
        VStack(alignment: .center) {
            Toggle(isOn: driverStatus.isOnline) {
                if (driverStatus.isOnline.wrappedValue) {
                    Text("Online")
                }
                else {
                    Text("Offline")
                }
            }

            if (driverStatus.isOnline.wrappedValue) {
                Toggle(isOn: driverStatus.ridesAvaliable) {
                    if (driverStatus.ridesAvaliable.wrappedValue) {
                        Text("Accepting Rides")
                    }
                    else {
                        Text("Not Accepting Rides")
                    }
                }
                
                Toggle(isOn: driverStatus.ordersAvailable) {
                    if (driverStatus.ordersAvailable.wrappedValue) {
                        Text("Accepting Food Pickups")
                    }
                    else {
                        Text("Not Accepting Food Pickups")
                    }
                }
                
                Toggle(isOn: driverStatus.extrasAvailable) {
                    if (driverStatus.extrasAvailable.wrappedValue) {
                        Text("Offering Ride Extras")
                    }
                    else {
                        Text("Not Offering Ride Extras")
                    }
                }
            }
            
            Button(action: {driverStatus.isEditing.wrappedValue.toggle()}){
                Text("Save")
            }
            .buttonStyle(.borderless)
        }
    }
}


struct DriverMainView: View {
    @Environment(\.driverData) var driverData
    
    @State private var driverStatus: DriverStatus = DriverStatus()
    
    var body: some View {
        TabView() {
            DriverMapView()
                .tabItem {
                    Image(systemName: "car.side")
                    Text("Drive")
                }
            
            DriverRateView(driverStatus: $driverStatus)
                .tabItem {
                    Image(systemName: "dollarsign.circle")
                    Text("Rate")
                }
            
            DriverCommunityView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Community")
                }
            
            DriverProfileView()
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
