//
//  AdminUserAdministration.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct AdminUserAdministration: View {
    // Fetch all users from SwiftData
    @Query private var users: [User]

    init() {
        // Optional: sort users by name
        self._users = Query(sort: \.name, order: .forward)
    }

    var body: some View {
        ZStack {
            BackgroundView()

            List {
                ForEach(users) { user in
                    NavigationLink(destination: UserDetailProfileView(user: user)) {
                        AdminUserRowView(user: user)
                    }
                }
            }
            .scrollContentBackground(.hidden)     
            .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    NavigationStack {
        AdminUserAdministration()
    }
}
