//
//  CommonModels.swift
//  Migrate
//
//  Created by Santana Gonzales on 1/17/25.
//

import Foundation
import MapKit

struct RiderExtra: Identifiable {
    let id = UUID()
    var name: String
    var price: Double
    var isEnabled: Bool
    var description: String
}

struct Vehicle: Identifiable {
    let id = UUID()
    var make: String
    var model: String
    var year: Int
    var licensePlate: String
    var insuranceInfo: String
}

enum PreferenceEnum {
    case Preferred
    case NoPreference
    case NotPreferred
}

struct PreferenceSetting: Identifiable {
    let id = UUID()
    var preferenceVal: PreferenceEnum
}
