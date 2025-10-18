//
//  AdminUserAdministration.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AdminUserAdministration: View {
    var body: some View {
        // Displays a scrollable list of users
        List {
            // Iterates over mock user data
            ForEach(User.mockUsers) { user in
                // Navigates to a detailed profile view when tapped
                NavigationLink(destination: UserDetailProfileView(user: user)) {
                    // Custom row view for displaying user info
                    AdminUserRowView(user: user)
                }
            }
        }
    }
}

#Preview {
    // Wrap preview inside a NavigationStack for proper navigation context
    NavigationStack {
        AdminUserAdministration()
    }
}
