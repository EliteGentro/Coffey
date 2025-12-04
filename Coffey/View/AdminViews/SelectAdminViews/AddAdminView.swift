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
            TextField("Nombre", text: $name)

            TextField(emailInUseError ? "El correo ingresado pertenece a otro perfil" :
                (emailError ? "Ingresa un correo válido" : "Correo"),
                text: $correo
            )
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .autocorrectionDisabled(true)


            // Password field (PIN)
            HStack {
                Group {
                    if showPassword {
                        TextField(showPinErrorAlert ? "Ingresa un PIN numérico de 6 cifras" : "PIN",
                                  text: $password)
                            .keyboardType(.numbersAndPunctuation)
                    } else {
                        SecureField(showPinErrorAlert ? "Ingresa un PIN numérico de 6 cifras" : "PIN",
                                    text: $password)
                            .keyboardType(.numbersAndPunctuation)
                    }
                }
                Button { showPassword.toggle() } label: {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }

            // Confirm password field
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

            if !confirmPassword.isEmpty && password != confirmPassword {
                Text("Los PIN no coinciden")
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            Picker("Cooperativa", selection: $selectedCooperativa) {
                ForEach(cooperativas, id: \.self) { option in
                    Text(option.name).tag(Optional(option))
                }
            }

            Button("Guardar") {

                emailError = false
                emailInUseError = false

                // Validación email
                guard isValidEmail(correo) else {
                    emailError = true
                    return
                }

                do {
                    let descriptor = FetchDescriptor<Admin>(
                        predicate: #Predicate { $0.correo == correo && $0.isDeleted == false }
                    )
                    let matches = try context.fetch(descriptor)

                    if !matches.isEmpty {
                        // El correo está en uso
                        emailInUseError = true
                        emailError = false
                        return
                    } else {
                        emailInUseError = false
                    }
                } catch {
                    print("Error verificando correo: \(error)")
                }


                // Validación PIN numérico
                guard isValidNumericPin(password) else {
                    password = ""
                    confirmPassword = ""
                    showPinErrorAlert = true
                    return
                }

                // Validación confirmación
                guard password == confirmPassword else {
                    showPasswordMismatchAlert = true
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
                    cooperativa_id: 1,
                    password: combined,
                    updatedAt: Date()
                )

                context.insert(admin)
                try? context.save()
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.brown)
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


#Preview {
    AddAdminView(cooperativas: Cooperativa.mockCooperativas)
}
