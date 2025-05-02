import SwiftUI
import MapKit
import Observation

@Observable
class DriverSettings: BaseSettings {
    
    // driver specific
    var enableFavorites: Bool = false
    var enableMetals: Bool = false
    var enableRatings: Bool = false
}

struct DriverSettingsView: View {
    @Bindable var settings: DriverSettings
    @State private var showEmergencyContactForm = false
    
    @State private var newFirstName: String = ""
    @State private var newLastName: String = ""
    @State private var newPhoneNumber: String = ""

    var body: some View {
            Form {
                Section(header: Text("Visual Settings")) {
                    Toggle("Dark Mode", isOn: $settings.darkModeEnabled)
                    Toggle("In-App Animations", isOn: $settings.appAnimationsEnabled)
                    Picker("Unit Type", selection: $settings.unitType) {
                        ForEach(UnitType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                }

                Section(header: Text("Driver Settings")) {
                    Toggle("Enable Favorites", isOn: $settings.enableFavorites)
                    Toggle("Enable Driver Metals", isOn: $settings.enableMetals)
                    Toggle("Enable Driver Ratings", isOn: $settings.enableRatings)
                }
                
                Section(header: Text("Emergency SOS Settings")) {
                    Toggle("Enable SOS Mode", isOn: $settings.enableSOSMode)
                    
                    if settings.enableSOSMode {
                        Toggle("Share Location on SOS", isOn: $settings.shareLocationOnSOS)
                        Toggle("Share Live Location on SOS", isOn: $settings.shareLiveLocationOnSOS)
                        
                        if let contact = settings.emergencyContact {
                            VStack(alignment: .leading) {
                                Text("Emergency Contact:")
                                    .font(.headline)
                                Text("\(contact.firstName) \(contact.lastName)")
                                Text(contact.phoneNumber)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        } else {
                            Text("No Emergency Contact Set")
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Add / Edit Emergency Contact") {
                            showEmergencyContactForm = true
                        }
                    }
                }
            .sheet(isPresented: $showEmergencyContactForm) {
                NavigationView {
                    Form {
                        Section(header: Text("Emergency Contact Information")) {
                            TextField("First Name", text: $newFirstName)
                            TextField("Last Name", text: $newLastName)
                            TextField("Phone Number", text: $newPhoneNumber)
                                .keyboardType(.phonePad)
                        }
                        
                        Section {
                            Button("Save Contact") {
                                let contact = EmergencyContact(
                                    id: UUID(),
                                    firstName: newFirstName,
                                    lastName: newLastName,
                                    phoneNumber: newPhoneNumber
                                )
                                settings.emergencyContact = contact
                                showEmergencyContactForm = false
                                
                                // Clear form fields
                                newFirstName = ""
                                newLastName = ""
                                newPhoneNumber = ""
                            }
                            .disabled(newFirstName.isEmpty || newLastName.isEmpty || newPhoneNumber.isEmpty)
                        }
                    }
                    .navigationTitle("Emergency Contact")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showEmergencyContactForm = false
                            }
                        }
                    }
                }
            }
        }
    }
}

struct DriverSettingsView_Preview: PreviewProvider {
    static var previews: some View {
        DriverSettingsView(settings: DriverSettings())
    }
}
