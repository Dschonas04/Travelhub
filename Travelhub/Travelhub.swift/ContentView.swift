import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            MainTabView(isLoggedIn: $isLoggedIn)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}

#Preview {
    ContentView()
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
