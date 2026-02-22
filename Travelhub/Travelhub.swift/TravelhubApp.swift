import SwiftUI
import SwiftData

@main
struct TravelhubApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Trip.self,
            Friend.self,
            ChatMessage.self,
            BudgetExpense.self,
            RouteLocation.self,
            Poll.self,
            AppNotification.self,
            Agreement.self,
            TripMember.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
