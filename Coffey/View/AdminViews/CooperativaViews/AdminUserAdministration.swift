//
//  AdminUserAdministration.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AdminUserAdministration: View {
    var body: some View {
        NavigationStack{
            List{
                ForEach(User.mockUsers){ user in
                    NavigationLink(destination: UserDetailProfileView(user: user)) {
                        AdminUserRowView(user: user)
                    }

                    
                }
            }
        }
    }
}

#Preview {
    AdminUserAdministration()
}
