//
//  SelectAdminModeView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct SelectAdminModeView: View {
    var body: some View {
        NavigationStack{
            LazyVGrid(columns:[GridItem(.flexible())], spacing: 50){
                NavigationLink(destination: SelectUserView()){
                    MenuCellView(systemName: "person.3.fill", title: "Elegir Usuario a Capacitar")
                }
                NavigationLink(destination: AdminUserAdministration()){
                    MenuCellView(systemName: "person.2.badge.gearshape.fill", title: "Administrar Prestamos")
                }
                NavigationLink(destination: ManageContentsView()){
                    MenuCellView(systemName: "arrow.down.circle.fill", title: "Administrar Contenido")
                }
            }
        }
        .padding(50)
        .navigationTitle(Text("Seleccionar Modo de Administrador"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SelectAdminModeView()
}
