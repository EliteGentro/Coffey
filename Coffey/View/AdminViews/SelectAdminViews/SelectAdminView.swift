//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI

struct SelectAdminView: View {
    // Binding to manage navigation path
    @Binding private var path: NavigationPath
    var onReset: () -> Void
    // State to control the presentation of AddAdmin sheet
    @State private var isAddedPresented = false

    // Custom initializer for binding and reset action
    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
    }

    var body: some View {
        ScrollView {
            // Two-column grid for displaying admins
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                ForEach(Admin.mockAdmins) { admin in
                    // Navigate to AdminLoginView when an admin is tapped
                    NavigationLink(
                        destination: AdminLoginView(admin: admin, path: $path, onReset: onReset)
                    ) {
                        VStack(spacing: 8) {
                            InitialProfileCircleView(name: admin.name)
                            Text(admin.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                    }
                }
            }
            .padding()
            // Toolbar button to add a new admin
            .toolbar {
                ToolbarItem {
                    Button("Add Admin", systemImage: "plus") {
                        self.isAddedPresented = true
                    }
                }
            }
            // Sheet for adding a new admin
            .sheet(isPresented: self.$isAddedPresented) {
                AddAdminView()
                    .presentationDetents([.large])
            }
        }
        .navigationTitle("Select Admin")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        // Dummy state for preview
        @State var dummyPath = NavigationPath()
        SelectAdminView(path: $dummyPath)
    }
}
