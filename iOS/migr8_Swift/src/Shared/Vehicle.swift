import SwiftUI

enum VehicleType: String, CaseIterable, Codable {
    case sedan = "Sedan"
    case SUV = "SUV"
    case pickupTruck = "Pickup Truck"
    case boxTruck = "Box Truck"
    
    @ViewBuilder
    var icon: some View {
        switch self {
        case .boxTruck: Image(systemName: "truck.box")
            case .pickupTruck: Image(systemName: "truck.pickup.side")
            case .sedan: Image(systemName: "car.side")
            case .SUV: Image(systemName: "suv.side")
        }
    }
}

enum VehicleMake: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    case honda = "Honda"
    case toyota = "Toyota"
    case ford = "Ford"
    case chevrolet = "Chevrolet"
    case nissan = "Nissan"
    case bmw = "BMW"
    case mercedes = "Mercedes-Benz"
    case volkswagen = "Volkswagen"
    case subaru = "Subaru"
    case kia = "Kia"
    case hyundai = "Hyundai"
    case tesla = "Tesla"
    case jeep = "Jeep"
    case dodge = "Dodge"
    case lexus = "Lexus"
    case mazda = "Mazda"
}

enum USState: String, CaseIterable, Identifiable, Codable {
    var id: String { self.rawValue }
    
    case AL, AK, AZ, AR, CA, CO, CT, DE, FL, GA
    case HI, ID, IL, IN, IA, KS, KY, LA, ME, MD
    case MA, MI, MN, MS, MO, MT, NE, NV, NH, NJ
    case NM, NY, NC, ND, OH, OK, OR, PA, RI, SC
    case SD, TN, TX, UT, VT, VA, WA, WV, WI, WY
}

struct Vehicle: Hashable, Identifiable, Codable {
    var id: Self { self }
    var make: VehicleMake = .honda
    var model: String
    var year: Int16
    var plateNumber: String
    var plateState: USState
    var vehicleType: VehicleType
}

struct VehicleRow: View {
    @State var vehicle: Vehicle

    var body: some View {
        HStack {
            vehicle.vehicleType.icon
                .frame(width: 40, height: 40)
                .padding(.trailing, 8)

            VStack(alignment: .leading) {
                Text("\(String(vehicle.year)) \(vehicle.make.rawValue) \(vehicle.model)")
                    .font(.headline)
                Text("\(vehicle.plateState.rawValue) \(vehicle.plateNumber)" )
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct NewVehicleForm: View {
    @Environment(\.dismiss) var dismiss // Add this to dismiss after adding
    @Bindable var driverData: DriverData
    
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    @State private var selectedMake: VehicleMake = .honda
    @State private var selectedType: VehicleType = .sedan
    @State private var model: String = ""
    @State private var year: String = ""
    @State private var plateNumber: String = ""
    @State private var plateState: USState = .TX

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Vehicle")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(VehicleType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    Picker("Make", selection: $selectedMake) {
                        ForEach(VehicleMake.allCases) { make in
                            Text(make.rawValue).tag(make)
                        }
                    }
                    

                    TextField("Model", text: $model)
                    TextField("Year", text: $year)
                        .keyboardType(.numberPad)
                    TextField("Plate Number", text: $plateNumber)

                    Picker("Plate State", selection: $plateState) {
                        ForEach(USState.allCases) { state in
                            Text(state.rawValue).tag(state)
                        }
                    }
                    
                    Button("Add Vehicle") {
                        if let yearValue = Int16(year) {
                            if (yearValue < 1900 || yearValue > 2030) {
                                alertMessage = "Invalid year value"
                                showingAlert = true
                            } else {
                                let newVehicle = Vehicle(
                                    make: selectedMake,
                                    model: model,
                                    year: yearValue,
                                    plateNumber: plateNumber,
                                    plateState: plateState,
                                    vehicleType: selectedType
                                )
                                
                                driverData.vehicles.append(newVehicle)
                                dismiss() // Dismiss form
                            }
                        } else {
                            alertMessage = "Unable to use year as Int16. Enter a valid year."
                            showingAlert = true
                        }
                    }
                }
            }
            .alert("Failed to add vehicle", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { showingAlert = false }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

struct VehicleForm_Preview: PreviewProvider {
    static var previews: some View {
        NewVehicleForm(driverData: DriverData())
    }
}
