import SwiftUI
import MapKit

// View contains driver's setters for their
// rate and any offered RiderExtras.
struct DriverRateView: View {
    @Environment(ModelData.self) var modelData
    var driver: Driver
    
    var body: some View {
        @Bindable var driverData = driver.driverData

        Form {
            Section("Your Rates")
            {
                VStack {
                    DrierHourlyRateView(currentValue: $driverData.hourRate)
                    
                    Divider()
                    
                    DrierMileRateView(currentValue: $driverData.mileRate)
                }
            }
            
            Section("Your Offers")
            {
                OfferList(driverData: driverData)
            }
        }
    }
}

struct DriverRateGauge: View {
    @Binding var currentValue: Double
    @State var minValue: Double = 0.0
    @State var maxValue: Double = 50.50
    
    var rateColor : Color {
        if (currentValue >= maxValue) {
            return .red
        }
        else if (currentValue >= maxValue * 0.75) {
            return .orange
        }
        else if (currentValue >= maxValue * 0.5) {
            return .yellow
        }
        else {
            return .green
        }
    }
    
    var body: some View {
        Gauge(value: currentValue, in: minValue...maxValue) {
        } currentValueLabel: {
            Text(String(format: "$%2.2f", currentValue))
                .foregroundStyle(rateColor)
                .fontDesign(.monospaced)
        } minimumValueLabel: {
            Text(String(format: "%2.f", minValue))
                .foregroundStyle(Color.gray)
                .fontDesign(.monospaced)
        } maximumValueLabel: {
            Text(String(format: "$%2.f", maxValue))
                .foregroundStyle(Color.orange)
                .fontDesign(.monospaced)
        }
        .gaugeStyle(.accessoryCircular)
        .tint(Gradient(colors: [.green, .yellow, .red]))
    }
}

struct RateGaugeView : View {
    @Binding var currentValue: Double
    @State var minValue: Double = 0.0
    @State var maxValue: Double = 50.50
    
    var body: some View {
        VStack {
            DriverRateGauge(currentValue: $currentValue)
            
            HStack {
                Button(action: {
                    currentValue += 0.25
                    }) {
                    Label("Rate Increase", systemImage: "arrow.up")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.green)
                        .disabled(currentValue >= maxValue)
                        .frame(width: 30)
                }
                
                Button(action: {
                    currentValue -= 0.25
                    }) {
                    Label("Rate Decrease", systemImage: "arrow.down")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.red)
                        .disabled(currentValue <= minValue)
                        .frame(width: 30)
                }
            }
            .buttonStyle(.bordered)
        }
    }
}

struct DrierMileRateView : View {
    @Binding var currentValue: Double
    
    var body: some View {
        HStack {
            VStack {
                Text("Mile-ly Rate:")
                    .font(.headline)
                Text("$\((String(format: "%2.2f", currentValue))) / mile")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
            }
            .padding(15)
            
            Spacer()
            
            RateGaugeView(currentValue: $currentValue)
            .padding(15)
        }
    }
}

struct DrierHourlyRateView : View {
    @Binding var currentValue: Double
    
    var body: some View {
        HStack {
            VStack {
                Text("Hour-ly Rate:")
                    .font(.headline)
                Text("$\((String(format: "%2.2f", currentValue))) / hour")
                    .font(.subheadline)
                    .fontDesign(.monospaced)
            }
            .padding(15)
            
            Spacer()

            RateGaugeView(currentValue: $currentValue)
            .padding(15)

        }
    }
}



struct OfferList: View {
    @Bindable var driverData: DriverData

    @State private var editingOffer: Offer? = nil
    @State private var newPriceInput: String = ""
    
    func groupByCategory(_ items: [Offer]) -> [(OfferCategory, [Offer])] {
        var groupedOffers = Dictionary(grouping: items, by: { $0.category })
        return groupedOffers.sorted(by: { $0.key.rawValue < $1.key.rawValue })
    }

    var body: some View {
        List {
            ForEach(groupByCategory(self.driverData.offers.offers), id: \.0) { pair in
                Section(header: Text(verbatim: pair.0.headerDescription)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary))
                {
                    ForEach(pair.1) { offer in
                        offer.body()
                        .swipeActions(edge: .trailing) {
                            if offer.enabled {
                                Button(action: {
                                    self.editingOffer = offer
                                    self.newPriceInput = String(format: "%.2f", offer.price)
                                }) {
                                    Label("Rate", systemImage: "dollarsign.gauge.chart.lefthalf.righthalf")
                                }
                                .tint(.indigo)
                            }
                        }
                    }
                }
            }
        }.listStyle(.automatic)
        .sheet(item: $editingOffer) { offer in
            VStack(spacing: 20) {
                Text("Edit Rate")
                    .font(.headline)
                
                TextField("Enter new price", text: $newPriceInput)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                HStack {
                    Button("Cancel") {
                        editingOffer = nil
                    }
                    .foregroundColor(.red)

                    Spacer()

                    Button("Save") {
                        if let newPrice = Double(newPriceInput) {
                            offer.price = newPrice
                        }
                        editingOffer = nil
                    }
                    .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct DriverRateView_Preview: PreviewProvider {
    static var previews: some View {
        Form {
            Section("Your Rates")
            {
                VStack {
                    DrierHourlyRateView(currentValue: .constant(10.0))
                    
                    Divider()
                    
                    DrierMileRateView(currentValue: .constant(30.0))
                }
            }
            
            Section("Your Offers")
            {
                OfferList(driverData: DriverData())
            }
        }
    }
}
