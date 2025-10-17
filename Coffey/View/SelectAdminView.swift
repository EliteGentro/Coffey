//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct SelectAdminView: View {
    var body: some View {
        NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                            ForEach(Admin.mockAdmins) { admin in
                                NavigationLink(destination: AdminLoginView(admin: admin)) {
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue.opacity(0.8))
                                                .frame(width: 80, height: 80)
                                            Text(String(admin.name.prefix(1)).uppercased())
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        
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
                    }
                    .navigationTitle("Select Admin")
                    .navigationBarTitleDisplayMode(.inline)
                }
    }
}

#Preview {
    SelectAdminView()
}
