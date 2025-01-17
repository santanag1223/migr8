import SwiftUI
import MapKit

struct RiderProfileView: View {
    @ObservedObject var rider: Rider
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
                    RiderRideHistory(rider: self.rider)
                        .tag(0)
                    
                    RiderPreferencesEditor(rider: self.rider)
                        .tag(1)
                    
                    RiderProfileEditor(rider: self.rider)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Profile")
        }
    }
}

struct RiderRideHistory: View {
    @ObservedObject var rider: Rider
    
    var body: some View {
        List {
            // get ride history
            ForEach(0..<10) { _ in
                RideHistoryRow()
            }
        }
    }
}

struct RiderPreferencesEditor: View {
    @ObservedObject var rider: Rider

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


struct RiderProfileEditor: View {
    @ObservedObject var rider: Rider
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                // Add personal info fields
            }
        }
    }
}
