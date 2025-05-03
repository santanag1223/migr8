import SwiftUI
import MapKit

struct RiderProfileView: View {
    @Environment(\.userState) var userState
    @Environment(\.riderData) var riderData
    var rider: Rider
    @State private var selectedTab = 0
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Profile Section", selection: $selectedTab) {
                    Text("Profile").tag(0)
                    Text("Preferences").tag(1)
                    Text("History").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                TabView(selection: $selectedTab) {
                    RiderProfileEditor(riderData: riderData)
                        .tag(0)
                    
                    RiderPreferencesEditor(riderData: riderData)
                        .tag(1)
                    
                    RiderRideHistory(riderData: riderData)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Profile")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingLogoutAlert = true
                    }){
                        Image(systemName: "person.slash.fill")
                            .foregroundStyle(.red)
                    }
                    .padding(10)
                }
            })
            .alert("Logout", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) {
                    showingLogoutAlert = false
                }
                Button("Logout", role: .destructive) {
                    userState.isLoggedIn = false
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }
}

struct RiderRideHistory: View {
    @Bindable var riderData: RiderData

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
    @Bindable var riderData: RiderData
    
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
    @Bindable var riderData: RiderData

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                // Add personal info fields
            }
        }
    }
}
