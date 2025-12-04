//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI
import SwiftData

struct SelectUserView: View {
    @Binding private var path: NavigationPath
    var onReset: () -> Void
    @State private var isAddPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Query private var users: [User]
    @Query private var cooperativas: [Cooperativa]

    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
        self._users = Query(sort: \.name)
        self._cooperativas = Query(sort: \.name)
    }

    var body: some View {
        ZStack {
            BackgroundView()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                    ForEach(users) { user in
                        NavigationLink(destination: WelcomePageUser(user: user, path: $path, onReset: onReset)) {
                            VStack(spacing: 8) {
                                InitialProfileCircleView(name: user.name)
                                Text(user.name)
                                    .scaledFont(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Select User")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Add User", systemImage: "plus") {
                        if cooperativas.isEmpty {
                            alertMessage = "No se encontraron cooperativas. Inténtalo más tarde."
                            showAlert = true
                        } else {
                            isAddPresented = true
                        }
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .sheet(isPresented: $isAddPresented) {
                AddUserView(cooperativas: cooperativas)
                    .presentationDetents([.medium])
            }
        }
    }
}
#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        SelectUserView(path: $dummyPath)
        .withPreviewSettings()

    }
}
