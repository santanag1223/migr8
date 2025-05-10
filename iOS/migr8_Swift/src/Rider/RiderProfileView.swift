import SwiftUI

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
                    RiderProfileEditor()
                        .tag(0)
                    
                    RiderSettingsView(settings: RiderSettings())
                        .tag(1)
                    
                    RiderRideHistory()
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
    var body: some View {
        List {
            // get ride history
            ForEach(0..<10) { _ in
                RideHistoryRow()
            }
        }
    }
}



struct RiderProfileEditor: View {
    @Environment(\.userState) var userState
    @Environment(\.riderData) var riderData
    @State private var showingAddVehicleForm = false

    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                HStack(alignment: .center) {
                    VStack(alignment: .center ) {
                        // name
                        Text("👤 Name:")
                            .font(.caption2)
                            .padding(.bottom, 2)
                        Text(userState.firstName + " " + userState.lastName)
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        // rating
                        Text("⭐️ Average Rating:")
                            .font(.caption2)
                            .padding(.bottom, 2)
                        Text("\(String(format: "%2.2f", riderData.avgRating)) / 10")
                            .font(.headline)
                            .padding(.bottom, 10)
                        
                        // miles
                        Text("🛣️ Life-Time Distance:")
                            .font(.caption2)
                            .padding(.bottom, 2)
                        Text("\(String(format: "%.2f", riderData.lifetimeMiles))  miles")
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
                PreferenceEditorView(prefCollection: riderData.prefs)
            }
        }
    }
}
