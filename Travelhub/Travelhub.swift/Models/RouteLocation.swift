//
//  RouteLocation.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

@Model
final class RouteLocation {
    var id: String = UUID().uuidString
    var tripId: String
    var name: String
    var latitude: Double = 0
    var longitude: Double = 0
    var visitDate: Date
    var duration: Int = 1 // in days
    var notes: String = ""
    var order: Int = 0
    
    init(tripId: String, name: String, visitDate: Date) {
        self.tripId = tripId
        self.name = name
        self.visitDate = visitDate
    }
}
