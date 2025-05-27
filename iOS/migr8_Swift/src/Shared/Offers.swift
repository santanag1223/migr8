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
class Offer : Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var price: Float
    
    var icon: String?
    var category: OfferCategory
    var enabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case title, enabled, price
    }
        
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        self.title = title
        
        enabled = try container.decode(Bool.self, forKey: .enabled)
        price = try container.decode(Float.self, forKey: .price)
        
        let offer = FindOfferByTitle(title)
        
        icon = offer!.description
        category = offer!.category
        description = offer!.description
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(enabled, forKey: .enabled)
        try container.encode(price, forKey: .price)
    }
    
    init(
        title: String = "",
        description: String = "",
        enabled: Bool = false,
        price: Float = 0.0,
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
                        .foregroundColor(.indigo)
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
}

var DEFAULT_OFFERS : [Offer] = [
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

private func FindOfferByTitle(_ title: String) -> Offer? {
    return DEFAULT_OFFERS.first { $0.title == title }
}
