import Foundation
import SwiftUI
import MapKit

@Observable
class ModelData {
    var userState: UserState = load("userState.json")
}

// UserState model
struct UserState: Hashable, Codable, Identifiable {
    var firstName: String
    var lastName: String
    var id: Self { self }
    var isLoggedIn: Bool
    var isDriver: Bool
    var driverData: DriverData
    var riderData: RiderData
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
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
