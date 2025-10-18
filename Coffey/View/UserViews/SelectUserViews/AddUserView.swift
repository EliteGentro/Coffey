//
//  AddUserView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AddUserView: View {
    // Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    
    // Form state variables
    @State private var name: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedCooperativa = "Cooperativa1"
    @State private var cooperativa_options: [String] = ["Cooperativa1", "Cooperativa2", "Cooperativa3", "Cooperativa4"]
    
    // State to show alert for password mismatch (not implemented yet)
    @State private var showPasswordMismatchAlert: Bool = false

    var body: some View {
        // NavigationStack provides navigation context for this form
        NavigationStack {
            Form {
                // Text field for user name
                TextField("Nombre", text: $name)

                // Picker to select cooperativa
                Picker("Cooperativa", selection: $selectedCooperativa) {
                    ForEach(cooperativa_options, id: \.self) { option in
                        Text(option)
                    }
                }

                // Save button (functionality to be implemented)
                Button("Guardar") {
                    // Action goes here
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Agregar Usuario")
            .navigationBarTitleDisplayMode(.inline)
            // Toolbar with dismiss button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

#Preview {
    // No additional NavigationStack needed — view has its own
    AddUserView()
}
