//
//  Trip.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

@Model
final class Trip {
    @Attribute(.unique)
    var id: String

    var title: String
    var tripDescription: String
    var startDate: Foundation.Date
    var endDate: Foundation.Date
    var budget: Double

    // Simple array of member identifiers; store externally to avoid large inline blobs
    @Attribute(.externalStorage)
    var members: [String]

    var organizer: String
    var destination: String
    var imageURL: String
    var isActive: Bool

    init(
        id: String = Foundation.UUID().uuidString,
        title: String,
        tripDescription: String = "",
        startDate: Foundation.Date = Foundation.Date.distantPast,
        endDate: Foundation.Date = Foundation.Date.distantFuture,
        budget: Double = 0,
        members: [String] = [],
        organizer: String = "",
        destination: String = "",
        imageURL: String = "mountain.2",
        isActive: Bool = true
    ) {
        self.id = id
        self.title = title
        self.tripDescription = tripDescription
        self.startDate = startDate
        self.endDate = endDate
        self.budget = budget
        self.members = members
        self.organizer = organizer
        self.destination = destination
        self.imageURL = imageURL
        self.isActive = isActive
    }
}

