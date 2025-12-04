//
//  AdminUserRowView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct AdminUserRowView: View {
    // User data for the row
    let user: User
    @Query private var progresses: [Progress]
    @StateObject private var userVM = UserViewModel()
    
    var body: some View {
        HStack(spacing: 16) {
            // Circular view showing user's initials
            InitialProfileCircleView(name: user.name)
            
            // User info section (name and completed content count)
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .scaledFont(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Contenidos:")
                        .scaledFont(.subheadline)
                        .fontWeight(.bold)
                    Text("\(userVM.getContenidosTerminados(for: user, progresses: progresses))")
                        .scaledFont(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // User score section aligned to the right
            VStack(alignment: .trailing) {
                Text("Puntaje:")
                    .scaledFont(.subheadline)
                    .fontWeight(.bold)
                Text("\(userVM.getPuntajeAprendizaje(for: user, progresses: progresses))")
                    .scaledFont(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    // No NavigationStack needed (no NavigationLinks in this view)
    AdminUserRowView(user: User.mockUsers[0])
        .withPreviewSettings()

}
