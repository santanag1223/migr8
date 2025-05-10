import SwiftUI

struct DriverCommunityView: View {
    var driver: Driver
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Community Highlights")) {
                    NavigationLink("❤️ Local Favorites", destination: CommunityHighlightView())
                }

                Section(header: Text("Drivers Forums")) {
                    NavigationLink("🛣️ Drivers View", destination: DriversForumView())
                    NavigationLink("✊ Union Organizing", destination: DriversUnionOrgView())
                }

                Section(header: Text("General Forums")) {
                    NavigationLink("🗣️ Discussions", destination: AppGeneralForumView())
                    NavigationLink("🧑‍💻 Feature Feedback", destination: FeatureForumView())
                }
            }
            .navigationTitle("Community")
        }
    }
}

struct DriversForumView: View {
    var body: some View {
        Text("Drivers Forum")
    }
}

struct DriversUnionOrgView: View {
    var body: some View {
        Text("Union Organizing")
    }
}
