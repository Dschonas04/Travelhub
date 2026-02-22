import Foundation
import SwiftData

@Model
final class Agreement {
    var id: String = UUID().uuidString
    var tripId: String
    var title: String
    var descriptionText: String
    var createdBy: String
    var assignedTo: [String] = []
    var status: String = "offen"
    var category: String = "Sonstiges"
    var dueDate: Date = Date.distantFuture
    var hasDueDate: Bool = false
    var createdDate: Date = Date()
    var priority: String = "mittel"
    var votesYes: Int = 0
    var votesNo: Int = 0
    var isResolved: Bool = false

    init(tripId: String, title: String, descriptionText: String = "", createdBy: String, category: String = "Sonstiges", priority: String = "mittel") {
        self.tripId = tripId
        self.title = title
        self.descriptionText = descriptionText
        self.createdBy = createdBy
        self.category = category
        self.priority = priority
    }
}
