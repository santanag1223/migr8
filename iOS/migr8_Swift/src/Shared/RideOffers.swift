import SwiftUI
import Foundation
import UIKit

/// `OfferDetails` - Offers Drivers make to their Riders.
/// OfferDetailss are considered either a 'perk' (free OfferDetails) or an 'extra' (paid OfferDetails)

struct OfferDetails: Hashable, Identifiable, Codable {
    var id: Self { self }
    var title: String
    var description: String
    var enabled: Bool = false
    var price: Double = 0.0
    var icon: String? = nil
}

struct OfferData: Hashable, Identifiable, Codable {
    var id: Self { self }
    var enabled: Bool = false
    var price: Double = 0.0
    
    init(price: Double, enabled: Bool) {
        self.price = price
        self.enabled = enabled
    }
}

struct DriverOfferData: Hashable, Identifiable, Codable {
    var id: Self { self }
    var AdFree: OfferData = OfferData(price: 0.0, enabled:  false)
    var FreeWater: OfferData = OfferData(price: 0.0, enabled:  false)
    var HeatedSeats: OfferData = OfferData(price: 0.0, enabled:  false)
    var CooledSeats: OfferData = OfferData(price: 0.0, enabled:  false)
    var RiderAcControls: OfferData = OfferData(price: 0.0, enabled:  false)
    var SpaceousRide: OfferData = OfferData(price: 0.0, enabled:  false)
    var CargoSpace: OfferData = OfferData(price: 0.0, enabled:  false)
    var StereoShare: OfferData = OfferData(price: 0.0, enabled:  false)
    var SnackStop: OfferData = OfferData(price: 0.0, enabled:  false)
    var AdditionalStop: OfferData = OfferData(price: 0.0, enabled:  false)
    var LargeGroup: OfferData = OfferData(price: 0.0, enabled:  false)
    var LargeBaggage: OfferData = OfferData(price: 0.0, enabled:  false)
    var TruckBed: OfferData = OfferData(price: 0.0, enabled:  false)
    
    init(offerData: DriverOfferData? = nil) {
        if let offerData = offerData {
            self = offerData
        }
    }
}

var AdFreeOffer: OfferDetails = OfferDetails(
    title: "Ad-free Ride",
    description: "Driver uses ad-free music player.",
    icon: "tv.music.note.fill")

var FreeWaterOffer: OfferDetails = OfferDetails(
    title: "Free Water",
    description: "Complimentary water bottle.",
    icon: "waterbottle.fill")

var HeatedSeatsOffer: OfferDetails = OfferDetails(
    title: "Heated Seats",
    description: "Rider's seats can be heated.",
    icon: "carseat.right.and.heat.waves.fill")

var CooledSeatsOffer: OfferDetails = OfferDetails(
    title: "Cooled Seats",
    description: "Rider's seats can be cooled.",
    icon: "carseat.right.fan.fill")

var RiderAcControlsOffer: OfferDetails = OfferDetails(
    title: "Rider AC Controls",
    description: "Rider has own climate controls.",
    icon: "thermometer.transmission")

var SpaceousOfferDetails: OfferDetails = OfferDetails(
    title: "Spaceous Ride",
    description: "Larger ride cabin for more comfort.",
    icon: "space")

var CargoSpaceOffer: OfferDetails = OfferDetails(
    title: "Cargo Space",
    description: "Larger ride cabin for more comfort.",
    icon: "bag.badge.plus.fill")

var StereoShareOffer: OfferDetails = OfferDetails(
    title: "Stereo-Share",
    description: "Rider can also control ride's stereo.",
    icon: "audio.jack.stereo")

var SnackStopOffer: OfferDetails = OfferDetails(
    title: "Snack Stops",
    description: "Additional stop(s) ONLY at fast food or stores.",
    icon: "takeoutbag.and.cup.and.straw")

var AdditionalStopOffer: OfferDetails = OfferDetails(
    title: "Extra Stops",
    description: "Additional stop(s) before reaching your destination.",
    icon: "mappin.circle")

var LargeGroupOffer: OfferDetails = OfferDetails(
    title: "Large Group",
    description: "Additional rate for 4 or more passengers.",
    icon: "person.3.fill")

var LargeBaggageOffer: OfferDetails = OfferDetails(
    title: "Large Baggage",
    description: "Additional rate for 4 or more large luggage items.",
    icon: "truck.box")

var TruckBedOffer: OfferDetails = OfferDetails(
    title: "Truck Bed",
    description: "Riders can use the bed of your truck.",
    icon: "truck.pickup.side")
