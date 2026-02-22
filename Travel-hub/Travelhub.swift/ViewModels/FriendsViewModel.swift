//
//  FriendsViewModel.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData
import Observation

@Observable
class FriendsViewModel {
    func getAcceptedFriends(from friends: [Friend]) -> [Friend] {
        friends.filter { $0.status == "accepted" }
            .sorted { $0.friendName < $1.friendName }
    }
    
    func getPendingRequests(from friends: [Friend]) -> [Friend] {
        friends.filter { $0.status == "pending" }
    }
    
    func addFriend(_ name: String, email: String, modelContext: ModelContext) {
        let newFriend = Friend(friendName: name, friendEmail: email, status: "pending")
        modelContext.insert(newFriend)
        try? modelContext.save()
    }
    
    func acceptFriend(_ friend: Friend, modelContext: ModelContext) {
        friend.status = "accepted"
        try? modelContext.save()
    }
    
    func removeFriend(_ friend: Friend, modelContext: ModelContext) {
        modelContext.delete(friend)
        try? modelContext.save()
    }
}

