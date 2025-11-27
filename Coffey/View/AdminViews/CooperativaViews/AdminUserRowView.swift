//
//  AdminUserRowView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AdminUserRowView: View {
    // User data for the row
    let user: User

    var body: some View {
        HStack(spacing: 16) {
            // Circular view showing user's initials
            InitialProfileCircleView(name: user.name)

            // User info section (name and completed content count)
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.title3)
                    .fontWeight(.bold)

                HStack {
                    Text("Contenidos:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(user.contenidos_terminados)")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // User score section aligned to the right
            VStack(alignment: .trailing) {
                Text("Puntaje:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("\(user.puntaje_aprendizaje)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    // No NavigationStack needed (no NavigationLinks in this view)
    AdminUserRowView(user: User.mockUsers[0])
}
