import Foundation
import SwiftUI

struct EmergencyContact: Codable, Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var phoneNumber: String
}

enum UnitType: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    case customary = "Customary"
    case metric = "Metric"
}

@Observable
class BaseSettings: Codable, Identifiable {
    var id: UUID

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
        self.id = UUID()
    }
}
