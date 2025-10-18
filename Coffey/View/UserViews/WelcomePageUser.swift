//
//  WelcomePageUser.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct WelcomePageUser: View {
    let user : User
    var body: some View {
        NavigationStack{
        VStack(spacing:30){
            VStack{
                Text("Puntaje")
                Text("\(user.puntaje_aprendizaje)")
            }
                .font(.largeTitle.bold())
                .padding(40)
                .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
            HStack{
                Text("Nivel: 4")
                ProgressView(value:0.5, total:1)

                    .frame(width: 200)
                    .accentColor(Color(.systemGreen))
                    
                VStack{
                    Text("4/5")
                    Text("Cursos")
                }
                
            }
            .fontWeight(.bold)
            
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]) {
                    NavigationLink(destination: UserLearningView(user: user)) {
                        MenuCellView(systemName: "book.closed.fill", title: "Aprendizaje")
                    }
                    NavigationLink(destination: UserSettingsView(user: user)) {
                        MenuCellView(systemName: "wallet.bifold.fill", title: "Registro de Finanzas")
                    }
                    NavigationLink(destination: UserSettingsView(user: user)) {
                        MenuCellView(systemName: "gear", title: "Ajustes")
                    }
                }
            }
        }
        .padding(20)
        .navigationTitle("Hola, \(user.name)")
        .navigationBarTitleDisplayMode( .inline)
        
    }
}

#Preview {
    WelcomePageUser(user: User.mockUsers[1])
}
