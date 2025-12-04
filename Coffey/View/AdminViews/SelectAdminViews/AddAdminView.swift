//
//  AddAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData
import CryptoKit // Para cifrado
import KeychainSwift //Para guardar el pin

struct AddAdminView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    @Query private var cooperativas: [Cooperativa]
    
    @State private var name: String = ""
    @State private var correo: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var selectedCooperativa : Cooperativa?
    
    @State private var showPasswordMismatchAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    
    
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
            Form {
                TextField("Nombre", text: $name)
                TextField("Correo", text: $correo)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.emailAddress)
                
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
                        .scaledFont(.footnote)
                }
                
                Picker("Cooperativa", selection: $selectedCooperativa) {
                    ForEach(cooperativas, id: \.self) { option in
                        Text(option.name).tag(Optional(option))
                    }
                }
                
                Button("Guardar") {
                    if password == confirmPassword {
                        let admin = Admin(
                            admin_id: 0,
                            name : self.name,
                            correo : self.correo,
                            cooperativa_id: selectedCooperativa!.cooperativa_id,
                            password: self.password,
                            updatedAt: Date()
                        )
                        
                        self.context.insert(admin)
                        do{
                            try self.context.save()
                            let keychain = KeychainSwift()
                            let data = Data(password.utf8)
                            let hashedPassword = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()
                            keychain.set(hashedPassword, forKey: "admin_\(admin.id.uuidString)_pin")
                            dismiss()
                        } catch {
                            errorMessage = "Error al guardar: \(error.localizedDescription)"
                            showErrorAlert = true
                        }
                    } else {
                        showPasswordMismatchAlert = true
                    }
                }
                .buttonStyle(.borderedProminent).tint(.brown)
                .alert("Error", isPresented: $showPasswordMismatchAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Las contraseñas no coinciden. Inténtalo de nuevo.")
                }
                .alert("Error", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(errorMessage)
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


#Preview {
    AddAdminView()
        .withPreviewSettings()

}
