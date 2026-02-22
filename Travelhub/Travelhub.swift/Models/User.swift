//
//  User.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import Foundation
import SwiftData

@Model
final class User {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var profileImage: String = "person.circle.fill"
    var bio: String = ""
    var lastActive: Date = Date()
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
