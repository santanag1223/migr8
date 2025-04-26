import SwiftUI

struct PreferenceCollection: Hashable, Identifiable, Codable {
    var id: Self { self }
    var conversationPref: UInt8 = 1
    var foodPref: UInt8 = 1
    var musicPref: UInt8 = 1
    var podcastPref: UInt8 = 1
    var smokingPref: UInt8 = 1
}

struct PreferenceView {
    var title: String
    var description: String
    var icon: String
}

var conversationPrefView: PreferenceView = PreferenceView(
    title: "Conversation",
    description: "Casual conversation with your driver.",
    icon: "person.2.wave.2"
)

var foodPrefView: PreferenceView = PreferenceView(
    title: "Food / Drink",
    description: "Eating and drinking small items during ride. (please be respectful of your driver's ride)",
    icon: "takeoutbag.and.cup.and.straw"
)

var musicPrefView: PreferenceView = PreferenceView(
    title: "Music",
    description: "Music playing during ride.",
    icon: "music.note"
)

var podcastsPrefView: PreferenceView = PreferenceView(
    title: "News / Talk Media",
    description: "News & talk broadcasts during ride.",
    icon: "waveform"
)

var smokingPrefView: PreferenceView = PreferenceView(
    title: "Smoke / Vape",
    description: "Okay with smoking or vaping during ride. (possibly w/ windows down)",
    icon: "smoke"
)

struct PreferencePicker: View {
    @State var PreferenceView : PreferenceView
    @Binding var prefValue: UInt8
    var body: some View {
        HStack {
            Picker(
                selection: $prefValue,
                content: {
                    Text("🚫 Unfavored")
                        .tag(UInt8(0))
                        .scaledToFit()
                    
                    Text("✌️ No Pref")
                        .tag(UInt8(1))
                        .scaledToFit()
                    
                    Text("✅ Favored")
                        .tag(UInt8(2))
                        .scaledToFit()
                },
                label: {
                    Label(
                        title: {
                            Text(PreferenceView.title)
                                .font(.subheadline)
                        },
                        icon: {
                            Image(systemName: PreferenceView.icon)
                                .foregroundStyle(.indigo)
                        }
                    )
                }
            )
            .padding(5)
        }
    }
}

struct Preference_Preview : PreviewProvider {
    @State static var prefVal = UInt8(0)
    
    static var previews: some View {
        Form() {
            PreferencePicker(
                PreferenceView: conversationPrefView,
                prefValue: $prefVal
            )
            PreferencePicker(
                PreferenceView:foodPrefView,
                prefValue: $prefVal
            )
            PreferencePicker(
                PreferenceView: musicPrefView,
                prefValue: $prefVal
            )
            PreferencePicker(
                PreferenceView: podcastsPrefView,
                prefValue: $prefVal
            )
            PreferencePicker(
                PreferenceView: smokingPrefView,
                prefValue: $prefVal
            )
        }
        .padding(20)
    }
}
