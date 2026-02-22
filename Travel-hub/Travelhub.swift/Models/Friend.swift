//
//  Friend.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

@Model
final class Friend {
    var id: String = UUID().uuidString
    var friendName: String
    var friendEmail: String
    var status: String = "accepted" // "pending", "accepted", "blocked"
    var addedDate: Date = Date()
    var profileImage: String = "person.circle.fill"
    
    init(friendName: String, friendEmail: String, status: String = "pending") {
        self.friendName = friendName
        self.friendEmail = friendEmail
        self.status = status
    }
}
