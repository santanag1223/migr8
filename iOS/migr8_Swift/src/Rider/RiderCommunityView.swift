import SwiftUI

struct RiderCommunityView: View {
    var rider: Rider
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Community Highlights")) {
                    NavigationLink("❤️ Local Favorites", destination: CommunityHighlightView())
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
