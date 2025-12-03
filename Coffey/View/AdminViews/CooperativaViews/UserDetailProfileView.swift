//
//  UserDetailProfileView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI
import SwiftData

struct UserDetailProfileView: View {
    // The user whose details will be displayed
    let user: User
    @Query private var progresses: [Progress]
    @StateObject private var userVM = UserViewModel()
    
    var body: some View {
        ZStack{
            BackgroundView()
        VStack(spacing: 60) {
            // Profile circle showing user's initials
            InitialProfileCircleView(name: user.name)
            
            // User's full name displayed prominently
            Text(user.name)
                .font(Font.largeTitle.bold())
            
            // Section for user details
            VStack(alignment: .leading, spacing: 20) {
                // Cooperative info
                HStack {
                    Text("Cooperativa:")
                        .font(.title.bold())
                    Text("\(user.cooperativa_id)")
                        .font(.title)
                }
                
                // Completed content count
                HStack {
                    Text("Contenidos:")
                        .font(.title.bold())
                    Text("\(userVM.getContenidosTerminados(for: user, progresses: progresses))")
                        .font(.title)
                }
                
                // Learning score
                HStack {
                    Text("Puntaje:")
                        .font(.title.bold())
                    Text("\(userVM.getPuntajeAprendizaje(for: user, progresses: progresses))")
                        .font(.title)
                }
            }
            .padding()
            .glassCard()
        }
        }
    }
}

#Preview {
    // No NavigationStack needed — this view has no NavigationLinks
    UserDetailProfileView(user: User.mockUsers[1])
}
