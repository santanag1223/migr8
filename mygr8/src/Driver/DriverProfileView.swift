import Foundation
import SwiftUI
import MapKit

struct DriverProfileView: View {
    @ObservedObject var driver: Driver
    @ObservedObject var userState: UserState
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                // Custom tab picker
                Picker("Profile Section", selection: $selectedTab) {
                    Text("History").tag(0)
                    Text("Profile").tag(1)
                    Text("Preferences").tag(2)
                    Text("Settings").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $selectedTab) {
                    DriverRideHistory(driver: driver)
                        .tag(0)
                    
                    DriverProfileEditor(driver: driver)
                        .tag(1)
                    
                    DriverPreferencesEditor(driver: driver)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Profile")
        }
    }
}

struct DriverRideHistory: View {
    @ObservedObject var driver: Driver
    
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

struct DriverProfileEditor: View {
    @ObservedObject var driver: Driver

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                // Add personal info fields
            }
            
            Section(header: Text("Vehicles")) {
                ForEach(driver.vehicles) { vehicle in
                    VehicleRow(vehicle: vehicle)
                }
                
                Button("Add Vehicle") {
                    // Add new vehicle action
                }
            }
        }
    }
}

struct DriverPreferencesEditor: View {
    @ObservedObject var driver: Driver

    var body: some View {
        Form {
            Section(header: Text("Preferences Editor")) {
                // Add personal info fields
            }
            
            Section(header: Text("Preferences")) {
                Button("Add Pref") {
                    // Add new vehicle action
                }
            }
        }
    }
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
