//
//  Notification.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

@Model
final class AppNotification {
    var id: String = UUID().uuidString
    var userId: String
    var type: String // "friend_request", "trip_invite", "message", "poll", "expense"
    var relatedTripId: String = ""
    var relatedUserId: String = ""
    var title: String
    var body: String
    var isRead: Bool = false
    var timestamp: Date = Date()
    
    init(userId: String, type: String, title: String, body: String) {
        self.userId = userId
        self.type = type
        self.title = title
        self.body = body
    }
}
