import Foundation
import SwiftData

@Model
final class TripMember {
    var id: String = UUID().uuidString
    var tripId: String
    var userId: String
    var userName: String
    var userEmail: String
    var role: String = "Teilnehmer"
    var joinedDate: Date = Date()
    var isActive: Bool = true

    init(tripId: String, userId: String = UUID().uuidString, userName: String, userEmail: String = "", role: String = "Teilnehmer") {
        self.tripId = tripId
        self.userId = userId
        self.userName = userName
        self.userEmail = userEmail
        self.role = role
    }
}
