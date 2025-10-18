//
//  AddAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AddAdminView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var correo: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var selectedCooperativa = "Cooperativa1"
    @State private var cooperativa_options: [String] = ["Cooperativa1", "Cooperativa2", "Cooperativa3", "Cooperativa4"]
    
    @State private var showPasswordMismatchAlert: Bool = false
    
    var body: some View {
        Form {
            TextField("Nombre", text: $name)
            TextField("Correo", text: $correo)
            
            // Password field
            HStack {
                Group {
                    if showPassword {
                        TextField("Contraseña", text: $password)
                            .keyboardType(.numberPad)
                    } else {
                        SecureField("Contraseña", text: $password)
                            .keyboardType(.numberPad)
                    }
                }
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            
            // Confirm password field
            HStack {
                Group {
                    if showConfirmPassword {
                        TextField("Confirmar contraseña", text: $confirmPassword)
                            .keyboardType(.numberPad)
                    } else {
                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .keyboardType(.numberPad)
                    }
                }
                Button(action: {
                    showConfirmPassword.toggle()
                }) {
                    Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }
            
            // Validation text
            if !confirmPassword.isEmpty && password != confirmPassword {
                Text("⚠️ Las contraseñas no coinciden")
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            
            Picker("Cooperativa", selection: $selectedCooperativa) {
                ForEach(cooperativa_options, id: \.self) { option in
                    Text(option)
                }
            }
            
            Button("Guardar") {
                if password == confirmPassword {
                    // Save logic
                    dismiss()
                } else {
                    showPasswordMismatchAlert = true
                }
            }
            .buttonStyle(.borderedProminent)
            .alert("Error", isPresented: $showPasswordMismatchAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Las contraseñas no coinciden. Inténtalo de nuevo.")
            }
        }
        .navigationTitle("Agregar Administrador")
        .navigationBarTitleDisplayMode(.inline)
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


#Preview {
    AddAdminView()
}
