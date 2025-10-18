//
//  AdminUserRowView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AdminUserRowView: View {
    let user : User
    var body: some View {
        HStack(spacing: 16) {
            
            InitialProfileCircleView(name: user.name)
            
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                HStack {
                    Text("Contenidos:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(user.contenidos_terminados)")
                        .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            VStack(alignment: .trailing) {
                Text("Puntaje:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("\(user.puntaje_aprendizaje)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    AdminUserRowView(user : User.mockUsers[0])
}
