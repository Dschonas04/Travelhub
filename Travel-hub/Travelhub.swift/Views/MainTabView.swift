import SwiftUI
import SwiftData

struct MainTabView: View {
    @Binding var isLoggedIn: Bool
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TripsListView()
                .tabItem {
                    Label("Reisen", systemImage: "suitcase.rolling.fill")
                }
                .tag(0)

            SearchHubView()
                .tabItem {
                    Label("Entdecken", systemImage: "map.fill")
                }
                .tag(1)

            ChatListView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }
                .tag(2)

            ProfileView(isLoggedIn: $isLoggedIn)
                .tabItem {
                    Label("Einstellungen", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .tint(.appPrimary)
    }
}

#Preview {
    MainTabView(isLoggedIn: .constant(true))
        .modelContainer(for: [
            User.self,
            Trip.self,
            Friend.self,
            ChatMessage.self,
            BudgetExpense.self,
            RouteLocation.self,
            Poll.self,
            AppNotification.self
        ], inMemory: true)
}
