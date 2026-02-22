import Foundation
import SwiftData

@Model
final class ChatMessage {
    var id: String = UUID().uuidString
    var senderId: String
    var senderName: String
    var tripId: String
    var content: String
    var timestamp: Date = Date()
    var isRead: Bool = false
    var messageType: String = "text"
    var replyToId: String = ""
    var replyToSender: String = ""
    var replyToContent: String = ""
    var reactions: [String] = []
    var isPinned: Bool = false

    init(senderId: String, senderName: String, tripId: String, content: String, messageType: String = "text") {
        self.senderId = senderId
        self.senderName = senderName
        self.tripId = tripId
        self.content = content
        self.messageType = messageType
    }
}
