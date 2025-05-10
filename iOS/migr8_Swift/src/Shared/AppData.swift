import Foundation
import SwiftUI
import MapKit
import Observation

@Observable
class AppData {
    var userState: UserState = load("userState.json")
    var driverData: DriverData = load("driverData.json")
    var riderData: RiderData = load("riderData.json")
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}

// UserState model
@Observable
class UserState: Codable, Identifiable {
    var id: UUID = UUID()
    
    var isDriver: Bool = true
    var isLoggedIn: Bool = false

    var firstName: String = ""
    var lastName: String = ""
    
    private var imageName: String = ""
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates = Coordinates(latitude: 0, longitude: 0)
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case isDriver, isLoggedIn, firstName, lastName, imageName, coordinates
    }
    
    init() {
        
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isDriver = try container.decode(Bool.self, forKey: .isDriver)
        isLoggedIn = try container.decode(Bool.self, forKey: .isLoggedIn)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        imageName = try container.decode(String.self, forKey: .imageName)
        coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isDriver, forKey: .isDriver)
        try container.encode(isLoggedIn, forKey: .isLoggedIn)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(coordinates, forKey: .coordinates)
    }
    
    static func == (lhs: UserState, rhs: UserState) -> Bool {
        lhs.id == rhs.id
    }
}

// simple JSON file loader
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

// Environment extentions
struct UserStateKey: EnvironmentKey {
    static var defaultValue: UserState = UserState()
}

extension EnvironmentValues {
    var userState: UserState {
        get { self[UserStateKey.self] }
        set { self[UserStateKey.self] = newValue }
    }
}
