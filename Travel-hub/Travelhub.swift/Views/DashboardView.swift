import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query var trips: [Trip]
    @Query var messages: [ChatMessage]

    var body: some View {
        NavigationStack {
            TripsListView()
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: [Trip.self, ChatMessage.self], inMemory: true)
}
