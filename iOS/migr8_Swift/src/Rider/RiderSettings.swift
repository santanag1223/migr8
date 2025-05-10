import SwiftUI
import MapKit
import Observation

@Observable
class RiderSettings: BaseSettings {
    
    // rider specific
    
    enum CodingKeys: String, CodingKey {
        case darkModeEnabled, appAnimationsEnabled,
             unitType, enableSOSMode, emergencyContact,
             shareLocationOnSOS, shareLiveLocationOnSOS
    }
    
    override init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        darkModeEnabled = try container.decode(Bool.self, forKey: .darkModeEnabled)
        appAnimationsEnabled = try container.decode(Bool.self, forKey: .appAnimationsEnabled)
        unitType = try container.decode(UnitType.self, forKey: .unitType)
        enableSOSMode = try container.decode(Bool.self, forKey: .enableSOSMode)
        if let emergencyContact = try? container.decode(EmergencyContact.self, forKey: .emergencyContact) {
            self.emergencyContact = emergencyContact
        } else {
            self.emergencyContact = nil
        }
        emergencyContact = try container.decode(EmergencyContact.self, forKey: .emergencyContact)
        shareLocationOnSOS = try container.decode(Bool.self, forKey: .shareLocationOnSOS)
        shareLiveLocationOnSOS = try container.decode(Bool.self, forKey: .shareLiveLocationOnSOS)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(darkModeEnabled, forKey: .darkModeEnabled)
        try container.encode(appAnimationsEnabled, forKey: .appAnimationsEnabled)
        try container.encode(unitType, forKey: .unitType)
        try container.encode(enableSOSMode, forKey: .enableSOSMode)
        try container.encode(emergencyContact, forKey: .emergencyContact)
        try container.encode(shareLocationOnSOS, forKey: .shareLocationOnSOS)
        try container.encode(shareLiveLocationOnSOS, forKey: .shareLiveLocationOnSOS)
    }
}


struct RiderSettingsView: View {
    @Bindable var settings: RiderSettings
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

struct RiderSettingsView_Preview: PreviewProvider {
    static var previews: some View {
        RiderSettingsView(settings: RiderSettings())
    }
}
