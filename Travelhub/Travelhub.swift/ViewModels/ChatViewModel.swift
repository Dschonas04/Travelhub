//
//  ChatViewModel.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData
import Observation

@Observable
class ChatViewModel {
    var selectedTripId: String = ""
    
    func getMessagesForTrip(tripId: String, from messages: [ChatMessage]) -> [ChatMessage] {
        messages.filter { $0.tripId == tripId }
            .sorted { $0.timestamp < $1.timestamp }
    }
    
    func sendMessage(_ content: String, senderId: String, senderName: String, tripId: String, modelContext: ModelContext) {
        let message = ChatMessage(senderId: senderId, senderName: senderName, tripId: tripId, content: content)
        modelContext.insert(message)
        try? modelContext.save()
    }
}

