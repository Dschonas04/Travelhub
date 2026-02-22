//
//  UserAvatarView.swift
//  Travelhub
//
//  Created by Jonas Groll on 11.02.26.
//

import SwiftUI

struct UserAvatarView: View {
    let name: String
    var size: CGFloat = 44
    
    var initials: String {
        name.split(separator: " ")
            .prefix(2)
            .map { String($0.prefix(1)).uppercased() }
            .joined()
    }
    
    var backgroundColor: Color {
        let colors: [Color] = [.blue, .green, .orange, .red, .purple, .pink]
        let index = name.hashValue % colors.count
        return colors[abs(index)]
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
            
            Text(initials)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: size, height: size)
    }
}
