import Foundation
import SwiftUI

class EmergencyContact: Codable, Identifiable {
    var id: UUID = UUID()
    var firstName: String = ""
    var lastName: String = ""
    var phoneNumber: String = ""
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, phoneNumber
    }
    
    init(firstName: String, lastName: String, phoneNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let firstName = try? container.decode(String?.self, forKey: .firstName) {
            self.firstName = firstName
            lastName = try container.decode(String.self, forKey: .lastName)
            phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        }
        else {
            return
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }

}

enum UnitType: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    case customary = "Customary"
    case metric = "Metric"
}

@Observable
class BaseSettings: Codable, Identifiable {
    var id: UUID = UUID()

    // visual settings
    var darkModeEnabled: Bool = false
    var appAnimationsEnabled: Bool = true
    
    // unit type
    var unitType: UnitType = .customary
    
    // SOS / emergency settings
    var enableSOSMode: Bool = false
    var emergencyContact: EmergencyContact? = nil
    var shareLocationOnSOS: Bool = false
    var shareLiveLocationOnSOS: Bool = false
    
    init() {
    }
}
