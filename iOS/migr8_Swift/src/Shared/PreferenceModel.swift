import SwiftUI
import Foundation
import UIKit

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
    icon: "person.2.wave.2.fill"
)

var foodPrefView: PreferenceView = PreferenceView(
    title: "Food & Drink",
    description: "Eating and drinking small items during ride. (please be respectful of your driver's ride)",
    icon: "takeoutbag.and.cup.and.straw"
)

var musicPrefView: PreferenceView = PreferenceView(
    title: "Music",
    description: "Music playing during ride.",
    icon: "music.note"
)

var podcastsPrefView: PreferenceView = PreferenceView(
    title: "Podcasts & Talk Radio",
    description: "News & talk broadcasts during ride.",
    icon: "waveform"
)

var smokingPrefView: PreferenceView = PreferenceView(
    title: "Smoking & Vaping",
    description: "Okay with smoking or vaping during ride. (possibly w/ windows down)",
    icon: "smoke.fill"
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
                        },
                        icon: {
                            Image(systemName: PreferenceView.icon)
                        }
                    )
                }
            )
            .font(.system(size: 14, weight: .regular))
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
