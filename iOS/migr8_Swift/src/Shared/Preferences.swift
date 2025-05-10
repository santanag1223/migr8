import SwiftUI
import Observation

@Observable
class PreferenceCollection: Identifiable, Codable {
    static func == (lhs: PreferenceCollection, rhs: PreferenceCollection) -> Bool {
        lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case convo, food, music, podcast, smoke
    }
    
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        convo = try container.decode(UInt8.self, forKey: .convo)
        food = try container.decode(UInt8.self, forKey: .food)
        music = try container.decode(UInt8.self, forKey: .music)
        podcast = try container.decode(UInt8.self, forKey: .podcast)
        smoke = try container.decode(UInt8.self, forKey: .smoke)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(convo, forKey: .convo)
        try container.encode(food, forKey: .food)
        try container.encode(music, forKey: .music)
        try container.encode(podcast, forKey: .podcast)
        try container.encode(smoke, forKey: .smoke)
    }
    
    var id = UUID()
    var convo: UInt8 = 1
    var food: UInt8 = 1
    var music: UInt8 = 1
    var podcast: UInt8 = 1
    var smoke: UInt8 = 1
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

struct PreferenceEditorView: View {
    @Bindable var prefCollection: PreferenceCollection
    
    var body: some View {
        PreferencePicker(
            PreferenceView: conversationPrefView,
            prefValue: $prefCollection.convo
        )
        PreferencePicker(
            PreferenceView: foodPrefView,
            prefValue: $prefCollection.food
        )
        PreferencePicker(
            PreferenceView: musicPrefView,
            prefValue: $prefCollection.music
        )
        PreferencePicker(
            PreferenceView: podcastsPrefView,
            prefValue: $prefCollection.podcast
        )
        PreferencePicker(
            PreferenceView: smokingPrefView,
            prefValue: $prefCollection.smoke
        )
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
