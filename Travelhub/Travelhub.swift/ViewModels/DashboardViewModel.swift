//
//  DashboardViewModel.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import Observation
import SwiftData

@Observable
class DashboardViewModel {

    func getUpcomingTrips(from trips: [Trip]) -> [Trip] {
        trips.filter { $0.startDate > Date() && $0.isActive }
            .sorted { $0.startDate < $1.startDate }
    }
    
    func getActiveTrips(from trips: [Trip]) -> [Trip] {
        trips.filter { $0.startDate <= Date() && $0.endDate >= Date() && $0.isActive }
    }
    
    func getRecentMessages(from messages: [ChatMessage]) -> [ChatMessage] {
        messages.sorted { $0.timestamp > $1.timestamp }.prefix(3).map { $0 }
    }
    
    func getTotalBudget(from trips: [Trip]) -> Double {
        trips.filter { $0.isActive }.reduce(0) { $0 + $1.budget }
    }
}

