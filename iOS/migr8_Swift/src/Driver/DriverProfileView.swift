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
                    Text("Settings").tag(1)
                    Text("History").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $selectedTab) {
                    DriverProfileEditor(driverData: driverData)
                        .tag(0)
                    
                    DriverSettingsView(settings: driverData.settings)
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
    @State private var showingAddVehicleForm = false


    var body: some View {
        let modelData = self.modelData
        
        Form {
            Section(header: Text("Personal Information")) {
                HStack(alignment: .center) {
                    VStack(alignment: .center ) {
                        // name
                        Text("👤 Name:")
                            .font(.caption2)
                            .padding(.bottom, 2)
                        Text(modelData.userState.firstName + " " + modelData.userState.lastName)
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        // rating
                        Text("⭐️ Average Rating:")
                            .font(.caption2)
                            .padding(.bottom, 2)
                        Text("\(String(format: "%2.2f", driverData.avgRating)) / 10")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        // miles
                        Text("🛣️ Life-Time Distance:")
                            .font(.caption2)
                            .padding(.bottom, 2)
                        Text("\(String(format: "%.2f", driverData.lifetimeMiles))  miles")
                            .font(.headline)
                            //.padding(.bottom, 10)
                        
                        // Add personal info fields

                        Spacer()
                    }
                    .padding(15)
                    Spacer()
                    Image("jpork")
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .frame(width: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.indigo, lineWidth: 6))
                }
            }
            
            Section(header: Text("Preferences")) {
                DriverPreferencesEditor(driverData: driverData)
            }
            
            Section(header: Text("Vehicles")) {
                ForEach(driverData.vehicles) { vehicle in
                    VehicleRow(vehicle: vehicle)
                }
                
                Button("Add Vehicle") {
                    showingAddVehicleForm = true
                }
                .sheet(isPresented: $showingAddVehicleForm) {
                    NewVehicleForm(driverData: driverData)
                }
            }
        }
    }
}

 struct DriverProfileView_Preview: PreviewProvider {
    static var previews: some View {
        DriverProfileEditor(driverData: DriverData())
            .environment(ModelData())
   }
}
