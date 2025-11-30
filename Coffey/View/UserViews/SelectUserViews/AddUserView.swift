//
//  AddUserView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct AddUserView: View {
    // Environment variable to dismiss the view
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // Form state variables
    @State private var name: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedCooperativa : Cooperativa?
    @Query private var cooperativas: [Cooperativa]
    
    // State to show alert for password mismatch (not implemented yet)
    @State private var showPasswordMismatchAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        // NavigationStack provides navigation context for this form
        NavigationStack {
            ZStack{
                Color.beige.ignoresSafeArea()
                Form {
                    // Text field for user name
                    TextField("Nombre", text: $name)
                    
                    // Picker to select cooperativa
                    Picker("Cooperativa", selection: $selectedCooperativa) {
                        ForEach(cooperativas, id: \.self) { option in
                            Text(option.name).tag(Optional(option))
                        }
                    }
                    
                    // Save button (functionality to be implemented)
                    Button("Guardar") {
                        let user = User(
                            user_id: 0,
                            name : self.name,
                            cooperativa_id: selectedCooperativa!.cooperativa_id,
                            updatedAt: Date()
                        )
                        let preference = Preference(
                            preference_id: nil,
                            user_id: 0,
                            local_user_reference: user.id,
                            font_multiplier: 1.0,
                            updatedAt: Date()
                        )
                        
                        self.context.insert(user)
                        self.context.insert(preference)
                        do{
                            try self.context.save()
                            dismiss()
                        } catch{
                            errorMessage = "Error al guardar: \(error.localizedDescription)"
                            showErrorAlert = true
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brown)
                }
                .navigationTitle("Agregar Usuario")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Error", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
                }
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
                .onAppear {
                    if cooperativas.count > 0 {
                        if selectedCooperativa == nil {
                            selectedCooperativa = cooperativas.first
                        }
                        
                    } else{
                        showErrorAlert = true
                        errorMessage = "No se encontraron cooperativas. Inténtalo más tarde."
                        dismiss()
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
