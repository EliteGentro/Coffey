//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct SelectAdminView: View {
    @Binding private var path: NavigationPath
    var onReset: () -> Void
    @State private var isAddedPresented = false
    @State private var isEditing = false
    @State private var adminToDelete: Admin?
    @State private var showDeleteAlert = false

    @Query private var admins: [Admin]
    @Environment(\.modelContext) private var context

    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
        self._admins = Query(sort: \.name, order: .forward)
    }

    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],
                      spacing: 32) {

                ForEach(admins) { admin in
                    ZStack(alignment: .topTrailing) {

                        if !isEditing {
                            NavigationLink(
                                destination: AdminLoginView(admin: admin, path: $path, onReset: onReset)
                            ) {
                                adminCard(admin)
                            }
                        } else {
                            adminCard(admin)
                                .overlay(
                                    deleteButton(for: admin)
                                        .padding(4)
                                        .offset(x: -38, y: -34)
                                )
                                .animation(.easeInOut.repeatForever(autoreverses: true),
                                           value: isEditing)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Select Admin")
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
                    self.isAddedPresented = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
            }
        }

        .sheet(isPresented: self.$isAddedPresented) {
            AddAdminView()
                .presentationDetents([.large])
        }

        // ALERT de confirmación
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

    // MARK: - COMPONENTES

    private func adminCard(_ admin: Admin) -> some View {
        VStack(spacing: 8) {
            InitialProfileCircleView(name: admin.name)
            Text(admin.name)
                .font(.headline)
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
                .font(.title2)
                .padding(6)
        }
        .offset(x: 12, y: -12)
    }

    // MARK: - DELETE LOGIC

    private func deleteAdmin(_ admin: Admin) {
        context.delete(admin)
        try? context.save()
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    NavigationStack {
        SelectAdminView(path: $dummyPath)
    }
}


//Este es el select anterior, lo guardo por si acaso
//
//struct SelectAdminView: View {
//    @Binding private var path: NavigationPath
//    var onReset: () -> Void
//    @State private var isAddedPresented = false
//
//    // Fetch admins from SwiftData
//    @Query private var admins: [Admin]
//
//    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
//        self._path = path
//        self.onReset = onReset
//        // Query all admins sorted by name
//        self._admins = Query(sort: \.name, order: .forward)
//    }
//
//    var body: some View {
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
//                ForEach(admins) { admin in
//                    NavigationLink(
//                        destination: AdminLoginView(admin: admin, path: $path, onReset: onReset)
//                    ) {
//                        VStack(spacing: 8) {
//                            InitialProfileCircleView(name: admin.name)
//                            Text(admin.name)
//                                .font(.headline)
//                                .foregroundColor(.primary)
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .padding()
//            .toolbar {
//                ToolbarItem {
//                    Button("Add Admin", systemImage: "plus") {
//                        self.isAddedPresented = true
//                    }.buttonStyle(.borderedProminent).tint(.brown)
//                }
//            }
//            .sheet(isPresented: self.$isAddedPresented) {
//                AddAdminView()
//                    .presentationDetents([.large])
//            }
//        }
//        .navigationTitle("Select Admin")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//

