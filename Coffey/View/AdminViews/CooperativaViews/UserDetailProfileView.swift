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
            Color.beige.ignoresSafeArea()
        VStack(spacing: 60) {
            // Profile circle showing user's initials
            InitialProfileCircleView(name: user.name)
            
            // User's full name displayed prominently
            Text(user.name)
                .scaledFont(.largeTitle).bold()
            
            // Section for user details
            VStack(alignment: .leading, spacing: 20) {
                // Cooperative info
                HStack {
                    Text("Cooperativa:")
                        .scaledFont(.title).bold()
                    Text("\(user.cooperativa_id)")
                        .scaledFont(.title)
                }
                
                // Completed content count
                HStack {
                    Text("Contenidos:")
                        .scaledFont(.title).bold()
                    Text("\(userVM.getContenidosTerminados(for: user, progresses: progresses))")
                        .scaledFont(.title)
                }
                
                // Learning score
                HStack {
                    Text("Puntaje:")
                        .scaledFont(.title).bold()
                    Text("\(userVM.getPuntajeAprendizaje(for: user, progresses: progresses))")
                        .scaledFont(.title)
                }
            }
        }
        }
    }
}

#Preview {
    // No NavigationStack needed — this view has no NavigationLinks
    UserDetailProfileView(user: User.mockUsers[1])
}
