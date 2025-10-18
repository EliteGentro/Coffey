//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct SelectUserView: View {
    @State private var isAddedPresented : Bool = false
    var body: some View {
        NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                            ForEach(User.mockUsers) { user in
                                NavigationLink(destination: WelcomePageUser(user: user)) {
                                    VStack(spacing: 8) {
                                        InitialProfileCircleView(name: user.name)
                                        
                                        // Name below
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
                            ToolbarItem{
                                Button("Add User", systemImage: "plus"){
                                    self.isAddedPresented = true
                                }.buttonStyle(.glass)
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
    SelectUserView()
}
