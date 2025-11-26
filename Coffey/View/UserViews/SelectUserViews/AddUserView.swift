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
    @State private var selectedCooperativa = "Cooperativa1"
    @State private var cooperativa_options: [String] = ["Cooperativa1", "Cooperativa2", "Cooperativa3", "Cooperativa4"]
    
    // State to show alert for password mismatch (not implemented yet)
    @State private var showPasswordMismatchAlert: Bool = false

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
                    ForEach(cooperativa_options, id: \.self) { option in
                        Text(option)
                    }
                }

                // Save button (functionality to be implemented)
                Button("Guardar") {
                    let user = User(
                        user_id: 0,
                        name : self.name,
                        cooperativa_id: 123, //missing logic to ingtegrate cooperativa objects
                        puntaje_aprendizaje: 0,
                        contenidos_terminados: 0,
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
                    } catch{
                        print(error)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brown)
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
}

#Preview {
    // No additional NavigationStack needed — view has its own
    AddUserView()
}
