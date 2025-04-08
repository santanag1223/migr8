import SwiftUI
import MapKit

struct RiderProfileView: View {
    @Environment(ModelData.self) var modelData: ModelData
    @ObservedObject var rider: Rider
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false
    
    var body: some View {
        @Bindable var modelData = modelData
        @ObservedObject var rider = rider
        
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
                    RiderProfileEditor(rider: rider)
                        .tag(0)
                    
                    RiderPreferencesEditor(riderData: $rider.riderData)
                        .tag(1)
                    
                    RiderRideHistory(rider: rider)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLogoutAlert = true
                    }){
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
    @Binding var riderData: RiderData
    
    var body: some View {

        Form() {
            PreferencePicker(
                PreferenceView: conversationPrefView,
                prefValue: $riderData.prefs.conversationPref
            )
            PreferencePicker(
                PreferenceView: foodPrefView,
                prefValue: $riderData.prefs.foodPref
            )
            PreferencePicker(
                PreferenceView: musicPrefView,
                prefValue: $riderData.prefs.musicPref
            )
            PreferencePicker(
                PreferenceView: podcastsPrefView,
                prefValue: $riderData.prefs.podcastPref
            )
            PreferencePicker(
                PreferenceView: smokingPrefView,
                prefValue: $riderData.prefs.smokingPref
            )
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
