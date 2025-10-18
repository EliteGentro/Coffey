//
//  UserDetailProfileView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct UserDetailProfileView: View {
    let user : User
    var body: some View {
        VStack(spacing: 60){
            InitialProfileCircleView(name: user.name)
            Text(user.name)
                .font(Font.largeTitle.bold())
            VStack(alignment: .leading, spacing: 20){
                HStack{
                    Text("Cooperativa:")
                        .font(.title.bold())
                    Text("\(user.cooperativa_id)")
                        .font(.title)
                }
                HStack{
                    Text("Contenidos:")
                        .font(.title.bold())
                    Text("\(user.contenidos_terminados)")
                        .font(.title)
                }
                HStack{
                    Text("Puntaje:")
                        .font(.title.bold())
                    Text("\(user.puntaje_aprendizaje)")
                        .font(.title)
                }
            }
        }
    }
}

#Preview {
    UserDetailProfileView(user: User.mockUsers[1])
}
