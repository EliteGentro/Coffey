//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI

struct SelectUserView: View {
    // Binding to manage navigation path
    @Binding private var path: NavigationPath
    var onReset: () -> Void
    // State to control presentation of AddUser sheet
    @State private var isAddedPresented = false

    // Custom initializer for path and reset action
    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
    }

    var body: some View {
        ScrollView {
            // Two-column grid for displaying users
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                ForEach(User.mockUsers) { user in
                    // Navigate to WelcomePageUser when a user is tapped
                    NavigationLink(destination: WelcomePageUser(user: user, path: $path, onReset: onReset)) {
                        VStack(spacing: 8) {
                            InitialProfileCircleView(name: user.name)
                            Text(user.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                    }
                }
            }
            .padding()
            // Toolbar button to add a new user
            .toolbar {
                ToolbarItem {
                    Button("Add User", systemImage: "plus") {
                        self.isAddedPresented = true
                    }
                }
            }
            // Sheet for adding a new user
            .sheet(isPresented: self.$isAddedPresented) {
                AddUserView()
                    .presentationDetents([.medium])
            }
        }
        .navigationTitle("Select User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        SelectUserView(path: $dummyPath)
    }
}
