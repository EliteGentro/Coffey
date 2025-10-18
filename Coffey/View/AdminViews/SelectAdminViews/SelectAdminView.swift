//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct SelectAdminView: View {
    @State private var isAddedPresented : Bool = false
    var body: some View {
        NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                            ForEach(Admin.mockAdmins) { admin in
                                NavigationLink(destination: AdminLoginView(admin: admin)) {
                                    VStack(spacing: 8) {
                                        InitialProfileCircleView(name: admin.name)
                                        
                                        // Name below
                                        Text(admin.name)
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
                                Button("Add Admin", systemImage: "plus"){
                                    self.isAddedPresented = true
                                }.buttonStyle(.glass)
                            }
                        }
                        .sheet(isPresented: self.$isAddedPresented) {
                            AddAdminView()
                                .presentationDetents([.large])
                        }
                    }
                    .navigationTitle("Select Admin")
                    .navigationBarTitleDisplayMode(.inline)
                }
    }
}

#Preview {
    SelectAdminView()
}
