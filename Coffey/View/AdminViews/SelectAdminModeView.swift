//
//  SelectAdminModeView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI

struct SelectAdminModeView: View {
    // Binding for navigation path
    @Binding private var path: NavigationPath
    var onReset: () -> Void

    // Custom initializer for path and reset action
    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
    }

    var body: some View {
        // Single-column grid for admin mode options
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 50) {
            // Navigation to user selection view
            NavigationLink(destination: SelectUserView(path: $path, onReset: onReset)) {
                MenuCellView(systemName: "person.3.fill", title: "Elegir Usuario a Capacitar")
            }
            // Navigation to user administration
            NavigationLink(destination: AdminUserAdministration()) {
                MenuCellView(systemName: "person.2.badge.gearshape.fill", title: "Administrar Prestamos")
            }
            // Navigation to content management
            NavigationLink(destination: ManageContentsView()) {
                MenuCellView(systemName: "arrow.down.circle.fill", title: "Administrar Contenido")
            }
        }
        .padding(50)
        .navigationTitle("Seleccionar Modo de Administrador")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    // Wrap in NavigationStack because view contains NavigationLinks
    NavigationStack {
        SelectAdminModeView(path: $dummyPath)
    }
}
