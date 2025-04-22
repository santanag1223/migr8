import Foundation
import SwiftUI
import MapKit

struct DriverProfileView: View {
    @State var driver: Driver
    @Environment(ModelData.self) var modelData
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false

    var body: some View {
        @Bindable var driverData = self.driver.driverData
        
        NavigationView {
            VStack {
                // Custom tab picker
                Picker("Profile Section", selection: $selectedTab) {
                    Text("Profile").tag(0)
                    Text("Preferences").tag(1)
                    Text("History").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $selectedTab) {
                    DriverProfileEditor(driverData: driverData)
                        .tag(0)
                    
                    DriverPreferencesEditor(driverData: driverData)
                        .tag(1)
                   
                    DriverRideHistory(driver: driver)
                        .tag(2)

                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                    Image(systemName: "person.slash.fill")
                        .foregroundStyle(.red)
                    }
                    .padding(10)
                    }
                }
            }
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) {
                    showingLogoutAlert = false
                }
                Button("Logout", role: .destructive) {
                    modelData.userState.isLoggedIn = false
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
    }
}

struct DriverRideHistory: View {
    var driver: Driver
    
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                RideHistoryRow()
            }
        }
    }
}

struct RideHistoryRow: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ride to Downtown")
                .font(.headline)
            Text("January 14, 2025 • $24.50")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}


struct DriverPreferencesEditor: View {
    @Bindable var driverData: DriverData

    var body: some View {
            PreferencePicker(
                PreferenceView: conversationPrefView,
                prefValue: $driverData.prefs.conversationPref
            )
            
            PreferencePicker(
                PreferenceView: foodPrefView,
                prefValue: $driverData.prefs.foodPref
            )
            
            PreferencePicker(
                PreferenceView: musicPrefView,
                prefValue: $driverData.prefs.musicPref
            )
            
            PreferencePicker(
                PreferenceView: podcastsPrefView,
                prefValue: $driverData.prefs.podcastPref
            )
            
            PreferencePicker(
                PreferenceView: smokingPrefView,
                prefValue: $driverData.prefs.smokingPref
            )
    }
}

struct DriverProfileEditor: View {
    @Environment(ModelData.self) var modelData
    @Bindable var driverData: DriverData

    var body: some View {
        var modelData = self.modelData
        
        Form {
            Section(header: Text("Personal Information")) {
                Text(modelData.userState.firstName + " " + modelData.userState.lastName)
                // Add personal info fields
            }
            
            Section(header: Text("Preferences")) {
                DriverPreferencesEditor(driverData: driverData)
            }
            
            Section(header: Text("Vehicles")) {
                ForEach(driverData.vehicles) { vehicle in
                    VehicleRow(vehicle: vehicle)
                }
                
                Button("Add Vehicle") {
                    // Add new vehicle action
                }
            }
        }
    }
}

struct Vehicle: Hashable, Identifiable, Codable {
    var id: Self { self }
    var make: String
    var model: String
    var year: Int
    var licensePlate: String
    var insuranceInfo: String
}

struct VehicleRow: View {
    let vehicle: Vehicle
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(vehicle.year) \(vehicle.make) \(vehicle.model)")
                .font(.headline)
            Text(vehicle.licensePlate)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
