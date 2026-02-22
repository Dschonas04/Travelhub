import SwiftUI
import SwiftData

struct ChatView: View {
    let trip: Trip
    @Query var messages: [ChatMessage]
    @Query var members: [TripMember]
    @Environment(\.modelContext) private var modelContext

    @State private var messageText = ""
    @State private var showAttachmentOptions = false
    @State private var replyingTo: ChatMessage? = nil
    @State private var showGroupInfo = false
    @State private var showPinnedMessages = false

    var tripMessages: [ChatMessage] {
        messages.filter { $0.tripId == trip.id && $0.messageType != "system" }
            .sorted { $0.timestamp < $1.timestamp }
    }

    var allTripMessages: [ChatMessage] {
        messages.filter { $0.tripId == trip.id }
            .sorted { $0.timestamp < $1.timestamp }
    }

    var pinnedMessages: [ChatMessage] {
        tripMessages.filter { $0.isPinned }
    }

    var tripMembers: [TripMember] {
        members.filter { $0.tripId == trip.id && $0.isActive }
    }

    var groupedMessages: [(String, [ChatMessage])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: allTripMessages) { msg in
            calendar.startOfDay(for: msg.timestamp)
        }
        return grouped.sorted { $0.key < $1.key }.map { (dateLabel(for: $0.key), $0.value) }
    }

    func dateLabel(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return "Heute" }
        if calendar.isDateInYesterday(date) { return "Gestern" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Online members bar
            if !tripMembers.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(tripMembers, id: \.id) { member in
                            VStack(spacing: 4) {
                                ZStack(alignment: .bottomTrailing) {
                                    UserAvatarView(name: member.userName, size: 36)
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 10, height: 10)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                }
                                Text(member.userName.components(separatedBy: " ").first ?? "")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemBackground))
                Divider()
            }

            // Pinned message banner
            if let firstPinned = pinnedMessages.first {
                Button(action: { showPinnedMessages = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(firstPinned.content)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        Spacer()
                        if pinnedMessages.count > 1 {
                            Text("+\(pinnedMessages.count - 1)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Image(systemName: "chevron.right")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.orange.opacity(0.08))
                }
            }

            // Messages
            ScrollViewReader { reader in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(groupedMessages, id: \.0) { label, msgs in
                            Text(label)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 5)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .padding(.vertical, 8)

                            ForEach(msgs, id: \.id) { message in
                                ChatBubbleView(
                                    message: message,
                                    isCurrentUser: message.senderId == "CurrentUserID",
                                    onReply: { replyingTo = message },
                                    onReact: { emoji in toggleReaction(emoji, on: message) },
                                    onPin: { message.isPinned.toggle(); try? modelContext.save() },
                                    onDelete: { modelContext.delete(message); try? modelContext.save() }
                                )
                                .id(message.id)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                .onChange(of: allTripMessages.count) { _, _ in
                    if let last = allTripMessages.last {
                        withAnimation { reader.scrollTo(last.id, anchor: .bottom) }
                    }
                }
                .onAppear {
                    if let last = allTripMessages.last {
                        reader.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            // Reply preview
            if let reply = replyingTo {
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.appPrimary)
                        .frame(width: 3)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(reply.senderName)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.appPrimary)
                        Text(reply.content)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    Spacer()
                    Button(action: { replyingTo = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
            }

            // Input bar
            HStack(spacing: 8) {
                Button(action: { showAttachmentOptions = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.appPrimary)
                }

                TextField("Nachricht schreiben...", text: $messageText, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)

                if messageText.trimmingCharacters(in: .whitespaces).isEmpty {
                    Button(action: { sendAttachment(type: "voice", text: "Sprachnachricht") }) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.appPrimary)
                    }
                } else {
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.appPrimary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
        }
        .navigationTitle(trip.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showGroupInfo = true }) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.caption)
                        Text("\(max(tripMembers.count, trip.members.count))")
                            .font(.caption)
                    }
                    .foregroundColor(.appPrimary)
                }
            }
        }
        .confirmationDialog("Anhang senden", isPresented: $showAttachmentOptions) {
            Button("Kamera") { sendAttachment(type: "image", text: "Foto aufgenommen") }
            Button("Fotobibliothek") { sendAttachment(type: "image", text: "Foto geteilt") }
            Button("Standort teilen") { sendAttachment(type: "location", text: "Standort geteilt") }
            Button("Dokument") { sendAttachment(type: "document", text: "Dokument geteilt") }
            Button("Abbrechen", role: .cancel) { }
        }
        .sheet(isPresented: $showGroupInfo) {
            NavigationStack {
                GroupManagementView(trip: trip)
            }
        }
        .sheet(isPresented: $showPinnedMessages) {
            NavigationStack {
                PinnedMessagesView(messages: pinnedMessages)
            }
        }
    }

    private func sendMessage() {
        let trimmed = messageText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let msg = ChatMessage(senderId: "CurrentUserID", senderName: "Du", tripId: trip.id, content: trimmed)
        if let reply = replyingTo {
            msg.replyToId = reply.id
            msg.replyToSender = reply.senderName
            msg.replyToContent = reply.content
        }
        modelContext.insert(msg)
        try? modelContext.save()
        messageText = ""
        replyingTo = nil
    }

    private func sendAttachment(type: String, text: String) {
        let msg = ChatMessage(senderId: "CurrentUserID", senderName: "Du", tripId: trip.id, content: text, messageType: type)
        modelContext.insert(msg)
        try? modelContext.save()
    }

    private func toggleReaction(_ emoji: String, on message: ChatMessage) {
        let key = "\(emoji):Du"
        if let idx = message.reactions.firstIndex(of: key) {
            message.reactions.remove(at: idx)
        } else {
            message.reactions.append(key)
        }
        try? modelContext.save()
    }
}

// MARK: - Pinned Messages Sheet
struct PinnedMessagesView: View {
    let messages: [ChatMessage]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        List {
            if messages.isEmpty {
                Text("Keine angehefteten Nachrichten")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(messages, id: \.id) { message in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(message.senderName)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.appPrimary)
                            Spacer()
                            Text(message.timestamp.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Text(message.content)
                            .font(.body)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Angeheftete Nachrichten")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Fertig") { dismiss() }
            }
        }
    }
}
