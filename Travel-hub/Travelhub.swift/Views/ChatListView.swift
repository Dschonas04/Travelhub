import SwiftUI
import SwiftData

struct ChatListView: View {
    @Query var messages: [ChatMessage]
    @Query var trips: [Trip]
    @Query var members: [TripMember]
    @State private var searchText = ""

    var chats: [(Trip, ChatMessage?, Int)] {
        trips.map { trip in
            let tripMsgs = messages.filter { $0.tripId == trip.id }
            let lastMsg = tripMsgs.sorted { $0.timestamp > $1.timestamp }.first
            let unread = tripMsgs.filter { !$0.isRead && $0.senderId != "CurrentUserID" }.count
            return (trip, lastMsg, unread)
        }
        .sorted {
            ($0.1?.timestamp ?? $0.0.startDate) > ($1.1?.timestamp ?? $1.0.startDate)
        }
    }

    var filteredChats: [(Trip, ChatMessage?, Int)] {
        if searchText.isEmpty { return chats }
        return chats.filter { $0.0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var totalUnread: Int {
        chats.reduce(0) { $0 + $1.2 }
    }

    var body: some View {
        NavigationStack {
            Group {
                if filteredChats.isEmpty && searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.appPrimary.opacity(0.3))
                        Text("Noch keine Chats")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Erstelle oder tritt einer Reise bei,\num den Gruppenchat zu starten")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground)
                } else {
                    List {
                        ForEach(filteredChats, id: \.0.id) { trip, lastMessage, unreadCount in
                            NavigationLink(destination: ChatView(trip: trip)) {
                                ChatListRow(trip: trip, lastMessage: lastMessage, unreadCount: unreadCount)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: "Chat suchen...")
            .navigationTitle("Chats")
        }
    }
}

struct ChatListRow: View {
    let trip: Trip
    let lastMessage: ChatMessage?
    let unreadCount: Int

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.appPrimary, .appSecondary], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 52, height: 52)
                Image(systemName: tripIcon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(trip.title)
                        .font(.body)
                        .fontWeight(unreadCount > 0 ? .bold : .semibold)
                        .lineLimit(1)
                    Spacer()
                    if let msg = lastMessage {
                        Text(timeLabel(for: msg.timestamp))
                            .font(.caption2)
                            .foregroundColor(unreadCount > 0 ? .appPrimary : .gray)
                    }
                }

                HStack {
                    Group {
                        if let msg = lastMessage {
                            if msg.messageType != "text" {
                                HStack(spacing: 4) {
                                    Image(systemName: attachmentIcon(for: msg.messageType))
                                        .font(.caption2)
                                    Text(msg.content)
                                }
                            } else if msg.senderId == "CurrentUserID" {
                                Text("Du: \(msg.content)")
                            } else {
                                Text("\(msg.senderName): \(msg.content)")
                            }
                        } else {
                            Text("Noch keine Nachrichten")
                                .italic()
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(1)

                    Spacer()

                    if unreadCount > 0 {
                        Text("\(unreadCount)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(minWidth: 22, minHeight: 22)
                            .background(Color.appPrimary)
                            .cornerRadius(11)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }

    var tripIcon: String {
        let dest = trip.destination.lowercased()
        if dest.contains("strand") || dest.contains("beach") || dest.contains("mallorca") || dest.contains("ibiza") { return "sun.max.fill" }
        if dest.contains("berg") || dest.contains("alp") || dest.contains("ski") { return "mountain.2.fill" }
        return "airplane"
    }

    func attachmentIcon(for type: String) -> String {
        switch type {
        case "image": return "photo.fill"
        case "voice": return "waveform"
        case "location": return "location.fill"
        default: return "doc.fill"
        }
    }

    func timeLabel(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return date.formatted(date: .omitted, time: .shortened) }
        if calendar.isDateInYesterday(date) { return "Gestern" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}

#Preview {
    ChatListView()
        .modelContainer(for: [ChatMessage.self, Trip.self, TripMember.self], inMemory: true)
}
