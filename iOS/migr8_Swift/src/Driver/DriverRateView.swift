import SwiftUI
import MapKit

// View contains driver's setters for their
// rate and any offered RiderExtras.
struct DriverRateView: View {
    @Environment(ModelData.self) var modelData
    @ObservedObject var driver: Driver
    
    var body: some View {
        @Bindable var modelData = modelData
        return NavigationStack {
            // Current Rate Display
            currentRateSection(driverRate: $modelData.userState.driverData.ratePerMile)
            
            //
            rideOffersSection(offerData: $modelData.userState.driverData.offers)
            }
            .navigationTitle("Your Rate & Offers")
            .padding()
        }
    }
    
    private func statusToggleButton(driver: Driver) -> some View {
        return Button(action: { withAnimation { driver.isAvailable = !driver.isAvailable }}) {
            Text(driver.isAvailable ? "Go Offline" : "Go Online")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(driver.isAvailable ? Color.purple : Color.green)
                .cornerRadius(10)
            }
            .padding(.horizontal)
    }
    
    private func currentRateSection(driverRate: Binding<Double>) -> some View {
        return NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Stepper(value: driverRate,
                                    in: 0...10,
                                    label: {Text("$ per mile: \(driverRate)") })
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .navigationTitle(Text("Current Rate"))
    }
    
private func rideOffersSection(offerData: Binding<DriverOfferData>) -> some View {
    return DriverOfferView(driverOfferData: offerData)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
}

struct DriverOfferView: View {
    @Binding var driverOfferData: DriverOfferData

    var body: some View {
        return NavigationStack {
            Form {
                Section("Free Perks") {
                    offerToggleRow(
                        offerDetail: FreeWaterOffer,
                        offerData: $driverOfferData.FreeWater)
                }
                
                Section("Entertainment") {
                    offerToggleRow(
                        offerDetail: StereoShareOffer,
                        offerData: $driverOfferData.StereoShare,
                        offerPrice: $driverOfferData.StereoShare.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: AdFreeOffer,
                        offerData: $driverOfferData.AdFree)
                }
                
                Section("Seat Features") {
                    offerToggleRow(
                        offerDetail: HeatedSeatsOffer,
                        offerData: $driverOfferData.HeatedSeats,
                        offerPrice: $driverOfferData.HeatedSeats.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: CooledSeatsOffer,
                        offerData: $driverOfferData.CooledSeats,
                        offerPrice: $driverOfferData.CooledSeats.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: RiderAcControlsOffer,
                        offerData: $driverOfferData.RiderAcControls,
                        offerPrice: $driverOfferData.RiderAcControls.price,
                        showPrice: true)
                }
                
                Section("Space & Comfort") {
                    offerToggleRow(
                        offerDetail: SpaceousOfferDetails,
                        offerData: $driverOfferData.SpaceousRide,
                        offerPrice: $driverOfferData.SpaceousRide.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: CargoSpaceOffer,
                        offerData: $driverOfferData.CargoSpace,
                        offerPrice: $driverOfferData.CargoSpace.price,
                        showPrice: true)
                }
                
                Section("Stops & Accommodations") {
                    offerToggleRow(
                        offerDetail: SnackStopOffer,
                        offerData: $driverOfferData.SnackStop,
                        offerPrice: $driverOfferData.SnackStop.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: AdditionalStopOffer,
                        offerData: $driverOfferData.AdditionalStop,
                        offerPrice: $driverOfferData.AdditionalStop.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: LargeGroupOffer,
                        offerData: $driverOfferData.LargeGroup,
                        offerPrice: $driverOfferData.LargeGroup.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: LargeBaggageOffer,
                        offerData: $driverOfferData.LargeBaggage,
                        offerPrice: $driverOfferData.LargeBaggage.price,
                        showPrice: true)
                    
                    offerToggleRow(
                        offerDetail: TruckBedOffer,
                        offerData: $driverOfferData.TruckBed,
                        offerPrice: $driverOfferData.TruckBed.price,
                        showPrice: true)
                }
            }
            .navigationTitle("Ride Offers")
        }
    }
    
    @ViewBuilder
    func offerToggleRow(offerDetail: OfferDetails, offerData: Binding<OfferData>, offerPrice : Binding<Double>? = nil, showPrice: Bool = false) -> some View {
        
        
        VStack(alignment: .leading) {
            HStack {
                if let iconName = offerDetail.icon {
                    Image(systemName: iconName)
                        .foregroundColor(.blue)
                        .frame(width: 28)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(offerDetail.title)
                        .font(.headline)
                        .foregroundColor(offerData.wrappedValue.enabled ? .primary : .secondary)
                    
                    Text(offerDetail.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if showPrice && offerData.wrappedValue.enabled {
                PriceStepper(
                    currentPrice: offerPrice.unsafelyUnwrapped
                )
                .padding(.leading, 32)
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PriceStepper: View {
    @State var stepLabel: String = "$"
    @State var priceStep: Double = 0.5
    @Binding var currentPrice: Double
    
    let maxPrice: Double = 5.0
    let minPrice: Double = 0.0
    
    func incrementStep() -> Void {
        if currentPrice < maxPrice - 0.5 {
            currentPrice += 0.5
        }
    }
    
    func decrementStep() -> Void {
        if currentPrice < minPrice + 0.5 {
            currentPrice -= 0.5
        }
    }
    
    var body: some View {
         Stepper {
             Text("\(stepLabel) \(currentPrice)")
         } onIncrement: {
             incrementStep()
         } onDecrement: {
             decrementStep()
         }
         .padding(5)
        }
}

// NumbersOnlyViewModifier to restrict text input to numbers for price fields
struct NumbersOnlyViewModifier: ViewModifier {
    @Binding var text: String
    var includeDecimal: Bool = true
    
    func body(content: Content) -> some View {
        content
            .keyboardType(.decimalPad)
    }
}

struct OfferDetailsManagementView_Previews: PreviewProvider {
    static var previews: some View {
        DriverOfferView(driverOfferData: .constant(DriverOfferData()))
    }
}
