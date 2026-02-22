//
//  FriendsView.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import SwiftUI
import SwiftData

struct FriendsView: View {
    @Query var friends: [Friend]
    @Environment(\.modelContext) private var modelContext
    @State private var showAddFriend = false
    @State private var selectedTab = "Friends"
    
    var acceptedFriends: [Friend] {
        friends.filter { $0.status == "accepted" }
    }
    
    var pendingRequests: [Friend] {
        friends.filter { $0.status == "pending" }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Tab Navigation
                HStack(spacing: 0) {
                    VStack {
                        Text("Friends")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        if selectedTab == "Friends" {
                            Capsule()
                                .fill(Color.blue)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = "Friends"
                        }
                    }
                    .padding(.vertical, 12)
                    
                    VStack {
                        HStack {
                            Text("Requests")
                                .font(.caption)
                                .fontWeight(.semibold)
                            
                            if !pendingRequests.isEmpty {
                                Text("\(pendingRequests.count)")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(width: 16, height: 16)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                        }
                        
                        if selectedTab == "Requests" {
                            Capsule()
                                .fill(Color.blue)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedTab = "Requests"
                        }
                    }
                    .padding(.vertical, 12)
                }
                .padding(.horizontal)
                .background(Color(.systemBackground))
                .border(Color.gray.opacity(0.2), width: 1)
                
                // Content
                ScrollView {
                    VStack(spacing: 12) {
                        if selectedTab == "Friends" {
                            if acceptedFriends.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "person.crop.circle")
                                        .font(.system(size: 48))
                                        .foregroundColor(.gray)
                                    
                                    Text("No friends yet")
                                        .font(.headline)
                                    
                                    Text("Add a friend to get started")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                            } else {
                                ForEach(acceptedFriends, id: \.id) { friend in
                                    FriendRowView(friend: friend, onRemove: {
                                        modelContext.delete(friend)
                                        try? modelContext.save()
                                    })
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            if pendingRequests.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 48))
                                        .foregroundColor(.green)
                                    
                                    Text("All caught up!")
                                        .font(.headline)
                                    
                                    Text("You have no pending requests")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .padding()
                            } else {
                                ForEach(pendingRequests, id: \.id) { friend in
                                    PendingRequestRowView(friend: friend, onAccept: {
                                        friend.status = "accepted"
                                        try? modelContext.save()
                                    }, onReject: {
                                        modelContext.delete(friend)
                                        try? modelContext.save()
                                    })
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Friends")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAddFriend = true }) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showAddFriend) {
                AddFriendView()
            }
        }
    }
}

struct FriendRowView: View {
    let friend: Friend
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            UserAvatarView(name: friend.friendName, size: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.friendName)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text(friend.friendEmail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Menu {
                Button(role: .destructive, action: onRemove) {
                    Label("Remove", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

struct PendingRequestRowView: View {
    let friend: Friend
    let onAccept: () -> Void
    let onReject: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            UserAvatarView(name: friend.friendName, size: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(friend.friendName)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Text(friend.friendEmail)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Button(action: onReject) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                
                Button(action: onAccept) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
}

#Preview {
    FriendsView()
        .modelContainer(for: Friend.self, inMemory: true)
}
