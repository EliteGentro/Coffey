//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
//  Edited by José Augusto Orozco Blas and Diego Hernandez on 1/12/25
import SwiftUI
import SwiftData

struct SelectAdminView: View {
    @Binding private var path: NavigationPath
    var onReset: () -> Void
    @State private var isAddedPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isEditing = false
    @State private var adminToDelete: Admin?      // Para alert
    @State private var showDeleteAlert = false
    private var api = AdminAPI()

    @Query(filter: #Predicate<Admin> { $0.deletedAt == nil },
           sort: \.name,
           order: .forward)
    private var admins: [Admin]
    @Query private var cooperativas: [Cooperativa]


    @Environment(\.modelContext) private var context

    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
    }

    var body: some View {
        ZStack{
            BackgroundView()
        ScrollView {



                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                    ForEach(admins) { admin in
                        ZStack(alignment: .topTrailing) {

                            if !isEditing {
                                NavigationLink(
                                    destination: AdminLoginView(
                                        admin: admin,
                                        path: $path,
                                        onReset: onReset)
                                ) {
                                    adminCard(admin)
                                }
                            } else {
                                adminCard(admin)
                                    .overlay(deleteButton(for: admin))
                                    .rotationEffect(.degrees(1.5))
                                    .animation(.easeInOut.repeatForever(autoreverses: true),
                                               value: isEditing)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Selecciona un perfil de administrador")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button(isEditing ? "OK" : "Edit") {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Admin", systemImage: "plus") {
                        if cooperativas.isEmpty {
                            alertMessage = "No se encontraron cooperativas. Inténtalo más tarde."
                            showAlert = true
                        } else {
                            isAddedPresented = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brown)
                }
            }

            .sheet(isPresented: self.$isAddedPresented) {
                AddAdminView(cooperativas: cooperativas)
                    .presentationDetents([.large])
            }

            .alert("¿Eliminar administrador?",
                   isPresented: $showDeleteAlert) {
                Button("Eliminar", role: .destructive) {
                    if let admin = adminToDelete {
                        deleteAdmin(admin)
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: {
                Text("Esta acción no se puede deshacer.")
            }
        }
    }

    // MARK: - COMPONENTES

    private func adminCard(_ admin: Admin) -> some View {
        VStack(spacing: 8) {
            InitialProfileCircleView(name: admin.name)
            Text(admin.name)
                .scaledFont(.headline)
                .foregroundColor(.primary)
        }
        .padding()
    }

    private func deleteButton(for admin: Admin) -> some View {
        Button {
            adminToDelete = admin
            showDeleteAlert = true
        } label: {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
                .scaledFont(.title2)
                .padding(6)
        }
        .offset(x: -46, y: -46)
    }

    // MARK: - SOFT DELETE
    private func deleteAdmin(_ admin: Admin) {
        admin.isDeleted = true
        admin.deletedAt = Date()
        try? context.save()
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    NavigationStack {
        SelectAdminView(path: $dummyPath)
        .withPreviewSettings()
    }
}
