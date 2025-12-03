//
//  WelcomePageUser.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI
import SwiftData

struct WelcomePageUser: View {
    // The user whose info is displayed
    let user: User
    // Environment dismiss for possible programmatic dismissal
    @Environment(\.dismiss) private var dismiss
    // Binding for navigation path
    @Binding private var path: NavigationPath
    // State for showing leave alert
    @State private var showLeaveAlert = false
    @Query private var progresses: [Progress]
    var filteredProgresses: [Progress] {
        progresses.filter { $0.user_id == user.user_id }
    }
    private var gradeSum: Int {
        filteredProgresses.reduce(0) { $0 + $1.grade }
    }
    private var completedProgresses: Int {
        filteredProgresses.filter({$0.status.rawValue == "completed"}).count
    }
    
    
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
            BackgroundView()
            
            VStack(spacing: 30) {
                
                // Score card
                VStack {
                    Text("Puntaje")
                    Text("\(self.gradeSum)")
                }
                .font(.largeTitle.bold())
                .padding(40)
                .glassCard()
                
                // Progress card
                HStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Progreso")
                            .font(.headline.bold())
                        
                        ProgressView(value: Double(completedProgresses % 5) / 5.0)
                            .tint(.green)
                        
                        HStack {
                            Text("Nivel \(completedProgresses/5 + 1)")
                            Spacer()
                            Text("\(completedProgresses % 5)/5 cursos")
                        }
                        .font(.subheadline.bold())
                    }
                    .padding()
                    .glassCard()
                }
                
                .frame(maxWidth: .infinity)
                
                // Menu
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    NavigationLink(destination: UserLearningView(user: user)) {
                        MenuCellView(systemName: "book.closed.fill", title: "Aprendizaje", color: .blue)
                    }
                    NavigationLink(destination: UserFinancesView(user: user)) {
                        MenuCellView(systemName: "wallet.bifold.fill", title: "Registro de Finanzas", color: .green)
                    }
                    NavigationLink(destination: UserSettingsView(user: user)) {
                        MenuCellView(systemName: "gear", title: "Ajustes", color: .gray)
                    }
                }
                .padding()
                
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            .padding(20)
            .navigationTitle("Hola, \(user.name)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            // Custom back button with alert
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showLeaveAlert = true
                    }) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    SectionAudioControls(text: "Test Audio Test Audio Test Audio Test Audio Test Audio Test Audio Test Audio Test Audio Test Audio Test Audio Test Audio")
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

