import SwiftUI
import Foundation
import UIKit
import Observation

enum OfferCategory: String, CaseIterable, CustomStringConvertible, Codable {
    case freeOffer = "free"
    case rideOffer = "ride"
    case utilOffer = "util"
    
    var description: String {
        self.rawValue.capitalized
    }
    
    var headerDescription: String {
        switch self {
            case .freeOffer: "🆓 Free Offers"
            case .rideOffer: "🚙 Ride Offers"
            case .utilOffer: "🛠️ Util Offers"
        }
    }
}

@Observable
class Offer : Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var enabled: Bool
    var price: Double
    var icon: String?
    var category: OfferCategory
    init(
        title: String = "",
        description: String = "",
        enabled: Bool = false,
        price: Double = 0.0,
        icon: String? = nil,
        category: OfferCategory = .rideOffer)
    {
        self.title = title
        self.description = description
        self.enabled = enabled
        self.price = price
        self.icon = icon
        self.category = category
    }
    
    func body() -> some View {
        return VStack(alignment: .leading) {
            HStack {
                if let iconName = self.icon {
                    Image(systemName: iconName)
                        .foregroundColor(.blue)
                        .frame(width: 28)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(self.title)
                        .font(.headline)
                        .foregroundColor(self.enabled ? .primary : .secondary)
                    
                    Text(self.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if self.enabled {
                    if self.category == .freeOffer ||
                        self.price == 0.0 {
                        Text("free")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .padding(.bottom, 20)
                            .foregroundColor(.primary)
                    }
                    else {
                        Text("$\((String(format: "%2.2f", self.price)))")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .padding(.bottom, 20)
                            .foregroundColor(.primary)
                    }
                }
                else {
                    Text("🚫")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .padding(.bottom, 20)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .leading) {
            Button(action: {
                self.enabled.toggle()
            }) {
                Label(self.enabled ? "Disable" : "Enable",
                      systemImage: self.enabled ? "nosign" : "checkmark.circle")
            }
            .tint(self.enabled ? .red : .green)
        }
    }
    
    func toggleEnabled() {
        enabled.toggle()
    }
    
    func toString() -> String {
        return "\(enabled);\(title);\(price)"
    }
    
    func fromString(_ input: String) {
        let parts = input.split(separator: ";")
        enabled = parts[0].trimmingCharacters(in: .whitespaces) == "true"
        title = parts[1].trimmingCharacters(in: .whitespaces)
        price = Double(parts[2].trimmingCharacters(in: .whitespaces)) ?? 0.0
    }
}

private var DEFAULT_OFFERS : [Offer] = [
        Offer(
            title: "Ad-free Music",
            description: "Use ad-free music services.",
            icon: "tv.music.note",
            category: .freeOffer),
        
        Offer(
            title: "Free Water",
            description: "Offer complimentary water bottle.",
            icon: "waterbottle",
            category: .freeOffer),
        
        Offer(
            title: "AC Controls",
            description: "Rider has own climate controls.",
            icon: "thermometer.transmission"),
        
        Offer(
            title: "Cooled Seats",
            description: "Rider seats can be cooled.",
            icon: "carseat.right.fan"),
        
        Offer(
            title: "Heated Seats",
            description: "Rider seats can be heated.",
            icon: "carseat.right.and.heat.waves"),
        
        Offer(
            title: "Spaceous Ride",
            description: "Larger ride cabin for more comfort.",
            icon: "space"),
        
        Offer(
            title: "Stereo-Share",
            description: "Rider can also control ride's stereo.",
            icon: "audio.jack.stereo"),
        
        Offer(
            title: "Extra Stops",
            description: "Additional stop(s) before reaching your destination.",
            icon: "mappin.circle",
            category: .utilOffer),
        
        Offer(
            title: "Snack Stops",
            description: "Additional stop(s) ONLY at fast food or convenience stores.",
            icon: "takeoutbag.and.cup.and.straw",
            category: .utilOffer),
        
        Offer(
            title: "Large Group Rate",
            description: "Additional rate for traveling with 4+ passengers.",
            icon: "person.3",
            category: .utilOffer),
        
        Offer(
            title: "Extra Cargo Rate",
            description: "Additional rate for traveling with excessive baggage.",
            icon: "truck.box",
            category: .utilOffer),
        
        Offer(
            title: "Truck Bed",
            description: "Additional rate for use of the truck bed.",
            icon: "truck.pickup.side",
            category: .utilOffer)
]

@Observable
final class OfferCollection {
    var offers: [Offer]
    init(offers: [Offer] = DEFAULT_OFFERS)
    {
        self.offers = offers
    }
}

// Environment extentions
private struct OfferCollectionKey: EnvironmentKey {
    static var defaultValue: OfferCollection = OfferCollection()
}

extension EnvironmentValues {
    var offers: OfferCollection {
        get { self[OfferCollectionKey.self] }
        set { self[OfferCollectionKey.self] = newValue }
    }
}
