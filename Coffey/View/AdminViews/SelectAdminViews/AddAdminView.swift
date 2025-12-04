//
//  AddAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//  Edited by Augusto Orozco on 21/11/25
//

import SwiftUI
import SwiftData
import CommonCrypto

struct AddAdminView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let cooperativas: [Cooperativa]

    @State private var name: String = ""
    @State private var correo: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showConfirmPassword: Bool = false
    @State private var selectedCooperativa : Cooperativa?

    @State private var showPasswordMismatchAlert: Bool = false
    @State private var showPinErrorAlert: Bool = false
    @State private var emailError: Bool = false
    @State private var emailInUseError: Bool = false
    @State private var nameError: Bool = false
    @State private var cooperativaError: Bool = false

    func isValidEmail(_ email: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(email.startIndex..<email.endIndex, in: email)
        let matches = detector?.matches(in: email, options: [], range: range)
        return matches?.first?.url?.scheme == "mailto" && matches?.first?.range == range
    }

    func isValidNumericPin(_ pin: String) -> Bool {
        return pin.count == 6 && pin.allSatisfy { $0.isNumber }
    }

    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""



    var body: some View {
        Form {
            Section(header: Text("Información Personal")) {
                VStack(alignment: .leading) {
                    TextField("Nombre", text: $name)
                    if nameError {
                        Text("El nombre es obligatorio")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading) {
                    TextField("Correo", text: $correo)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled(true)
                    
                    if emailInUseError {
                        Text("El correo ingresado pertenece a otro perfil")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    if emailError {
                        Text("Ingresa un correo válido")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }
            
            Section(header: Text("Seguridad")) {
                VStack(alignment: .leading) {
                    HStack {
                        Group {
                            if showPassword {
                                TextField("PIN", text: $password)
                                    .keyboardType(.numbersAndPunctuation)
                            } else {
                                SecureField("PIN", text: $password)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                        }
                        Button { showPassword.toggle() } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if showPinErrorAlert {
                        Text("Ingresa un PIN numérico de 6 cifras")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading) {
                    HStack {
                        Group {
                            if showConfirmPassword {
                                TextField("Confirmar PIN", text: $confirmPassword)
                                    .keyboardType(.numbersAndPunctuation)
                            } else {
                                SecureField("Confirmar PIN", text: $confirmPassword)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                        }
                        Button { showConfirmPassword.toggle() } label: {
                            Image(systemName: showConfirmPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if showPasswordMismatchAlert {
                        Text("Los PIN no coinciden")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }

            Section {
                VStack(alignment: .leading) {
                    Picker("Cooperativa", selection: $selectedCooperativa) {
                        ForEach(cooperativas, id: \.self) { option in
                            Text(option.name).tag(Optional(option))
                        }
                    }
                    if cooperativaError {
                        Text("Debes seleccionar una cooperativa")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
            }

            Section {
                Button("Guardar") {
                    // Reset all errors
                    nameError = false
                    emailError = false
                    emailInUseError = false
                    showPinErrorAlert = false
                    showPasswordMismatchAlert = false
                    cooperativaError = false
                    
                    var hasError = false

                    // Validate Name
                    if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        nameError = true
                        hasError = true
                    }

                    // Validate Email
                    if !isValidEmail(correo) {
                        emailError = true
                        hasError = true
                    } else {
                        // Check for existing email only if format is valid
                        do {
                            let descriptor = FetchDescriptor<Admin>(
                                predicate: #Predicate { $0.correo == correo && $0.isDeleted == false }
                            )
                            let matches = try context.fetch(descriptor)

                            if !matches.isEmpty {
                                emailInUseError = true
                                hasError = true
                            }
                        } catch {
                            print("Error verificando correo: \(error)")
                        }
                    }

                    // Validate PIN
                    if !isValidNumericPin(password) {
                        showPinErrorAlert = true
                        hasError = true
                    }

                    // Validate Confirm PIN
                    if password != confirmPassword {
                        showPasswordMismatchAlert = true
                        hasError = true
                    }
                    
                    // Validate Cooperativa
                    if selectedCooperativa == nil {
                        cooperativaError = true
                        hasError = true
                    }

                    if hasError {
                        return
                    }

                    // CIFRAR PIN
                    let salt = CryptoHelper.randomSalt()
                    guard let derived = CryptoHelper.pbkdf2Hash(password: password, salt: salt) else {
                        print("Error hashing PIN")
                        return
                    }

                    let combined = "\(CryptoHelper.encode(salt))|\(CryptoHelper.encode(derived))"

                    // Crear admin con PIN cifrado
                    let admin = Admin(
                        admin_id: 0,
                        name: name,
                        correo: correo,
                        cooperativa_id: selectedCooperativa!.cooperativa_id,
                        password: combined,
                        updatedAt: Date()
                    )

                    context.insert(admin)
                    try? context.save()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .frame(maxWidth: .infinity)
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
    AddAdminView(cooperativas: Cooperativa.mockCooperativas)
}
