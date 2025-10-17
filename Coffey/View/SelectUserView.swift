//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct SelectUserView: View {
    var body: some View {
        NavigationStack {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                            ForEach(User.mockUsers) { user in
                                NavigationLink(destination: WelcomePageUser(user: user)) {
                                    VStack(spacing: 8) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue.opacity(0.8))
                                                .frame(width: 80, height: 80)
                                            Text(String(user.name.prefix(1)).uppercased())
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                        
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
                    }
                    .navigationTitle("Select User")
                    .navigationBarTitleDisplayMode(.inline)
                }
    }
}

#Preview {
    SelectUserView()
}
