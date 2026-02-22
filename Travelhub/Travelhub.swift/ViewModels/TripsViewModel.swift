//
//  TripsViewModel.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData
import Observation

@Observable
class TripsViewModel {
    func getActiveTrips(from trips: [Trip]) -> [Trip] {
        trips.filter { $0.isActive && $0.startDate <= Date() && $0.endDate >= Date() }
            .sorted { $0.startDate < $1.startDate }
    }
    
    func getUpcomingTrips(from trips: [Trip]) -> [Trip] {
        trips.filter { $0.isActive && $0.startDate > Date() }
            .sorted { $0.startDate < $1.startDate }
    }
    
    func getPastTrips(from trips: [Trip]) -> [Trip] {
        trips.filter { !$0.isActive || $0.endDate < Date() }
            .sorted { $0.startDate > $1.startDate }
    }
    
    func addTrip(_ trip: Trip, modelContext: ModelContext) {
        modelContext.insert(trip)
        try? modelContext.save()
    }
    
    func updateTrip(_ trip: Trip, modelContext: ModelContext) {
        try? modelContext.save()
    }
    
    func deleteTrip(_ trip: Trip, modelContext: ModelContext) {
        modelContext.delete(trip)
        try? modelContext.save()
    }
}

