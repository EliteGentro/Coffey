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
    @Query private var progresses: [Progress]

    init() {
        self._users = Query(sort: \.name, order: .forward)
    }

    private func updateUserScores() {
        var userScores: [Int: Int] = [:]

        for progress in progresses {
            userScores[progress.user_id, default: 0] += progress.grade
        }

        for user in users {
            let score = userScores[user.user_id] ?? 0
            if user.puntaje_aprendizaje != score {
                user.puntaje_aprendizaje = score
            }
        }
    }

    var body: some View {
        ZStack {
            Color.beige.ignoresSafeArea()

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
        .onAppear {
            updateUserScores()
        }
    }
}

#Preview {
    NavigationStack {
        AdminUserAdministration()
    }
}
