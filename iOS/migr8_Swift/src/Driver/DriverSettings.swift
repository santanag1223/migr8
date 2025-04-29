import SwiftUI
import MapKit
import Observation

struct EmergencyContact: Codable, Identifiable {
    var id: UUID
    var firstName: String
    var lastName: String
    var phoneNumber: String
}

@Observable
class DriverSettings: Codable, Identifiable {
    var id: UUID
    
    // visual settings
    var darkModeEnabled: Bool
    var appAnimationsEnabled: Bool
    var imperialUnitsEnabled: Bool
    
    // driver specific settings
    var enableDriverFavorability: Bool
    var enableDriverRatings: Bool
    var enableDriverNotes: Bool
    
    // SOS Mode
    var enableSOSMode: Bool
    var emergencyContact: EmergencyContact?
    var shareLocationOnSOS: Bool
    var shareLiveLocationOnSOS: Bool
    
    init(id: UUID = UUID(),
         darkModeEnabled: Bool = false,
         appAnimationsEnabled: Bool = true,
         imperialUnitsEnabled: Bool = true,
         enableDriverFavorability: Bool = false,
         enableDriverRatings: Bool = false,
         enableDriverNotes: Bool = false,
         enableSOSMode: Bool = false,
         enableSOSModeEmergencyContact: EmergencyContact? = nil,
         shareLocationOnSOS: Bool = false,
         shareLiveLocationOnSOS: Bool = false)
    {
        self.id = id
        self.darkModeEnabled = darkModeEnabled
        self.appAnimationsEnabled = appAnimationsEnabled
        self.imperialUnitsEnabled = imperialUnitsEnabled
        self.enableDriverFavorability = enableDriverFavorability
        self.enableDriverRatings = enableDriverRatings
        self.enableDriverNotes = enableDriverNotes
        self.enableSOSMode = enableSOSMode
        self.emergencyContact = enableSOSModeEmergencyContact
        self.shareLocationOnSOS = shareLocationOnSOS
        self.shareLiveLocationOnSOS = shareLiveLocationOnSOS
    }
    
    required init(from: Decoder) {
        self.id = UUID()
        self.darkModeEnabled = false
        self.appAnimationsEnabled = true
        self.imperialUnitsEnabled = true
        self.enableDriverFavorability = false
        self.enableDriverRatings = false
        self.enableDriverNotes = false
        self.enableSOSMode = false
        self.shareLocationOnSOS = false
        self.shareLiveLocationOnSOS = false
    }
    
    func encode(to: Encoder) throws {
        
    }
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
                    Toggle("Use In-App Animations", isOn: $settings.appAnimationsEnabled)
                    Toggle("Use Imperial Units", isOn: $settings.imperialUnitsEnabled)
                    
                }
                
                Section(header: Text("Driver Preferences")) {
                    Toggle("Favorability Score", isOn: $settings.enableDriverFavorability)
                    Toggle("Driver Ratings", isOn: $settings.enableDriverRatings)
                    Toggle("Driver Notes", isOn: $settings.enableDriverNotes)
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
