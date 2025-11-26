//
//  WelcomePageUser.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI

struct WelcomePageUser: View {
    // The user whose info is displayed
    let user: User
    // Environment dismiss for possible programmatic dismissal
    @Environment(\.dismiss) private var dismiss
    // Binding for navigation path
    @Binding private var path: NavigationPath
    // State for showing leave alert
    @State private var showLeaveAlert = false
    // Optional closure to reset navigation when leaving
    var onReset: (() -> Void)? = nil
    
    // Custom initializer
    init(user: User, path: Binding<NavigationPath>, onReset: (() -> Void)? = nil) {
        self.user = user
        self._path = path
        self.onReset = onReset
    }
    
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
        VStack(spacing: 30) {
            // Display user score
            VStack {
                Text("Puntaje")
                Text("\(user.puntaje_aprendizaje)")
            }
            .font(.largeTitle.bold())
            .padding(40)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.brown.opacity(0.1)))
            
            // Display user level and course progress
            HStack {
                Text("Nivel: 4")
                ProgressView(value: 0.5, total: 1)
                    .frame(width: 200)
                    .accentColor(Color(.systemGreen))
                VStack {
                    Text("4/5")
                    Text("Cursos")
                }
            }
            .fontWeight(.bold)
            
            // Menu options with navigation
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                NavigationLink(destination: UserLearningView(user: user)) {
                    MenuCellView(systemName: "book.closed.fill", title: "Aprendizaje", color: .blue.opacity(0.8))
                }
                NavigationLink(destination: UserFinancesView(user: user)) {
                    MenuCellView(systemName: "wallet.bifold.fill", title: "Registro de Finanzas", color: .green.opacity(0.9))
                }
                NavigationLink(destination: UserSettingsView(user: user)) {
                    MenuCellView(systemName: "gear", title: "Ajustes", color: .gray)
                }
            }
        }
        .padding(20)
        .navigationTitle("Hola, \(user.name)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // Custom back button with alert
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showLeaveAlert = true
                }) {
                    Image(systemName: "chevron.left")
                }
            }
        }
        // Alert confirmation for leaving
        .alert("¿Seguro que quieres salir?", isPresented: $showLeaveAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Confirmar", role: .destructive) {
                onReset?()
            }
        } message: {
            Text("Llama a un administrador para volver a entrar.")
        }
        }
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        WelcomePageUser(user: User.mockUsers[1], path: $dummyPath)
    }
}

