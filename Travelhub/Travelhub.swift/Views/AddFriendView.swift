//
//  AddFriendView.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import SwiftUI
import SwiftData

struct AddFriendView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var friendName = ""
    @State private var friendEmail = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Friend Details") {
                    TextField("Name", text: $friendName)
                    TextField("Email", text: $friendEmail)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                
                Section {
                    Button(action: addFriend) {
                        Text("Send Request")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.blue)
                    }
                    .disabled(friendName.isEmpty || friendEmail.isEmpty)
                }
            }
            .navigationTitle("Add Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func addFriend() {
        let friend = Friend(friendName: friendName, friendEmail: friendEmail, status: "pending")
        modelContext.insert(friend)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    AddFriendView()
        .modelContainer(for: Friend.self, inMemory: true)
}
