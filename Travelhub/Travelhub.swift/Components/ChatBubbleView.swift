import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    let isCurrentUser: Bool
    var onReply: () -> Void = {}
    var onReact: (String) -> Void = { _ in }
    var onPin: () -> Void = {}
    var onDelete: () -> Void = {}

    var groupedReactions: [(String, Int)] {
        var counts: [String: Int] = [:]
        for r in message.reactions {
            let emoji = String(r.prefix(while: { $0 != ":" }))
            counts[emoji, default: 0] += 1
        }
        return counts.sorted { $0.key < $1.key }.map { ($0.key, $0.value) }
    }

    var body: some View {
        if message.messageType == "system" {
            systemBubble
        } else {
            messageBubble
        }
    }

    // MARK: - System Message
    var systemBubble: some View {
        HStack {
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "info.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(message.content)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            Spacer()
        }
        .padding(.vertical, 4)
    }

    // MARK: - Normal Message
    var messageBubble: some View {
        VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
            if !isCurrentUser {
                HStack(spacing: 6) {
                    UserAvatarView(name: message.senderName, size: 20)
                    Text(message.senderName)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 4)
            }

            HStack(alignment: .bottom, spacing: 4) {
                if isCurrentUser { Spacer(minLength: 60) }

                VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                    // Reply preview
                    if !message.replyToId.isEmpty {
                        HStack(spacing: 6) {
                            Rectangle()
                                .fill(isCurrentUser ? Color.white.opacity(0.5) : Color.appPrimary.opacity(0.6))
                                .frame(width: 2)
                            VStack(alignment: .leading, spacing: 1) {
                                Text(message.replyToSender)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(isCurrentUser ? .white.opacity(0.9) : .appPrimary)
                                Text(message.replyToContent)
                                    .font(.caption2)
                                    .foregroundColor(isCurrentUser ? .white.opacity(0.7) : .gray)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.bottom, 2)
                    }

                    // Content
                    messageContent
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background {
                    if isCurrentUser {
                        LinearGradient(colors: [.appPrimary, .appSecondary], startPoint: .topLeading, endPoint: .bottomTrailing)
                    } else {
                        Color(.systemGray6)
                    }
                }
                .cornerRadius(16, appCorners: isCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                .contextMenu {
                    Button(action: onReply) {
                        Label("Antworten", systemImage: "arrowshape.turn.up.left")
                    }
                    Menu {
                        Button("\u{1F44D}") { onReact("\u{1F44D}") }
                        Button("\u{2764}\u{FE0F}") { onReact("\u{2764}\u{FE0F}") }
                        Button("\u{1F602}") { onReact("\u{1F602}") }
                        Button("\u{1F62E}") { onReact("\u{1F62E}") }
                        Button("\u{1F389}") { onReact("\u{1F389}") }
                        Button("\u{1F64F}") { onReact("\u{1F64F}") }
                    } label: {
                        Label("Reagieren", systemImage: "face.smiling")
                    }
                    Button(action: {
                        UIPasteboard.general.string = message.content
                    }) {
                        Label("Kopieren", systemImage: "doc.on.doc")
                    }
                    Button(action: onPin) {
                        Label(message.isPinned ? "Lösen" : "Anheften", systemImage: message.isPinned ? "pin.slash" : "pin")
                    }
                    if isCurrentUser {
                        Divider()
                        Button(role: .destructive, action: onDelete) {
                            Label("Löschen", systemImage: "trash")
                        }
                    }
                }

                if !isCurrentUser { Spacer(minLength: 60) }
            }

            // Reactions
            if !groupedReactions.isEmpty {
                HStack(spacing: 4) {
                    ForEach(groupedReactions, id: \.0) { emoji, count in
                        HStack(spacing: 2) {
                            Text(emoji).font(.caption2)
                            if count > 1 {
                                Text("\(count)")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 4)
            }

            // Timestamp & receipt
            HStack(spacing: 4) {
                Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
                if isCurrentUser {
                    Image(systemName: message.isRead ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.caption2)
                        .foregroundColor(message.isRead ? .appPrimary : .gray)
                }
                if message.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            }
            .padding(.horizontal, 4)
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    var messageContent: some View {
        switch message.messageType {
        case "image":
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isCurrentUser ? Color.white.opacity(0.15) : Color.appPrimary.opacity(0.08))
                    .frame(height: 120)
                    .overlay {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 36))
                            .foregroundColor(isCurrentUser ? .white.opacity(0.7) : .appPrimary.opacity(0.5))
                    }
                Text(message.content)
                    .font(.caption)
                    .foregroundColor(isCurrentUser ? .white : .primary)
            }
        case "voice":
            HStack(spacing: 8) {
                Image(systemName: "play.circle.fill")
                    .font(.title3)
                    .foregroundColor(isCurrentUser ? .white : .appPrimary)
                RoundedRectangle(cornerRadius: 2)
                    .fill(isCurrentUser ? Color.white.opacity(0.4) : Color.appPrimary.opacity(0.3))
                    .frame(height: 4)
                Text("0:12")
                    .font(.caption2)
                    .foregroundColor(isCurrentUser ? .white.opacity(0.7) : .gray)
            }
            .frame(width: 160)
        case "location":
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isCurrentUser ? Color.white.opacity(0.15) : Color.green.opacity(0.08))
                    .frame(height: 80)
                    .overlay {
                        Image(systemName: "map.fill")
                            .font(.system(size: 28))
                            .foregroundColor(isCurrentUser ? .white.opacity(0.7) : .green.opacity(0.5))
                    }
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.caption2)
                    Text(message.content)
                        .font(.caption)
                }
                .foregroundColor(isCurrentUser ? .white : .primary)
            }
        default:
            Text(message.content)
                .foregroundColor(isCurrentUser ? .white : .primary)
        }
    }
}

// Custom corner radius
struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, appCorners corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}
