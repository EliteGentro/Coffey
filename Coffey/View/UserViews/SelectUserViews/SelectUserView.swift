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
    @State private var isAddedPresented = false
    
    // Fetch users from SwiftData
    @Query private var users: [User]
    
    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
        // Query all users
        self._users = Query(sort: \.name, order: .forward)
    }
    
    var body: some View {
        ZStack{
            BackgroundView()
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                ForEach(users) { user in
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
            .toolbar {
                ToolbarItem {
                    Button("Add User", systemImage: "plus") {
                        self.isAddedPresented = true
                    }
                }
            }
            .sheet(isPresented: self.$isAddedPresented) {
                AddUserView()
                    .presentationDetents([.medium])
            }
        }
        .navigationTitle("Select User")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        SelectUserView(path: $dummyPath)
    }
}
