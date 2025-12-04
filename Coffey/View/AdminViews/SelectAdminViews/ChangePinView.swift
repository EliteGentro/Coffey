//
//  ChangePinView.swift
//  Coffey
//
//  Created by Augusto Orozco on 07/11/25.
//
//

//Si revisaste esto y leiste todo este texto, saludame con otro comentario cuando hagas commit.

//Anota particularmente que cambiaste, para no perdernos y romper todo este codigo sacado de lo mas profundo de la BD de la IA. Tysm por leer esto :D

import SwiftUI
import CommonCrypto
import SwiftData

struct ChangePinView: View {
    @Environment(\.modelContext) private var context

    let admin: Admin
    let numberOfDigits: Int

    @State private var currentPin: [String]
    @State private var newPin: [String]
    @State private var confirmPin: [String]

    @State private var message: String = ""
    @State private var success: Bool = false

    init(admin: Admin, numberOfDigits: Int = 6) {
        self.admin = admin
        self.numberOfDigits = numberOfDigits
        _currentPin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        _newPin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        _confirmPin = State(initialValue: Array(repeating: "", count: numberOfDigits))
    }

    // MARK: - VALIDAR PIN CONTRA BD
    private func validateCurrentPin(_ pin: String) -> Bool {
        let stored = admin.password
        let parts = stored.split(separator: "|")
        guard parts.count == 2,
              let salt = CryptoHelper.decode(String(parts[0])),
              let storedKey = CryptoHelper.decode(String(parts[1])),
              let derived = CryptoHelper.pbkdf2Hash(password: pin, salt: salt)
        else {
            return false
        }

        return derived == storedKey
    }

    // MARK: - ACTUALIZAR PIN EN BD
    private func updatePin(_ newPin: String) {
        let salt = CryptoHelper.randomSalt()

        if let derived = CryptoHelper.pbkdf2Hash(password: newPin, salt: salt) {
            let combined = "\(CryptoHelper.encode(salt))|\(CryptoHelper.encode(derived))"
            admin.password = combined   // ✔ se actualiza directamente en la BD

            do { try context.save() }
            catch { print("Error al guardar nuevo PIN: \(error)") }
        }
    }

    // MARK: - UI
    var body: some View {
        ZStack {
            Color.beige.ignoresSafeArea()
        VStack(spacing: 24) {
            Image("Coffee-cup")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 40)

            Text("Cambiar PIN")
                .scaledFont(.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("PIN actual")
                        .scaledFont(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $currentPin, fieldFocus: _focusCurrent, numberOfDigits: numberOfDigits)
                }

                VStack(alignment: .leading) {
                    Text("Nuevo PIN")
                        .scaledFont(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $newPin, fieldFocus: _focusNew, numberOfDigits: numberOfDigits)
                }

                VStack(alignment: .leading) {
                    Text("Confirmar nuevo PIN")
                        .scaledFont(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $confirmPin, fieldFocus: _focusConfirm, numberOfDigits: numberOfDigits)
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 10)

            Button(action: handleChangePin) {
                Text("Guardar cambios")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)

            if !message.isEmpty {
                Text(message)
                    .foregroundColor(success ? .green : .red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Seguridad")
        }
    }

    // MARK: - LOGIC
    private func handleChangePin() {
        let current = currentPin.joined()
        let new = newPin.joined()
        let confirm = confirmPin.joined()

        guard !current.isEmpty, !new.isEmpty, !confirm.isEmpty else {
            message = "Todos los campos deben completarse."
            success = false
            return
        }

        guard validateCurrentPin(current) else {
            message = "El PIN actual no es correcto."
            success = false
            return
        }

        guard new == confirm else {
            message = "Los nuevos PIN no coinciden."
            success = false
            return
        }

        guard new.allSatisfy({ $0.isNumber }) else {
            message = "El nuevo PIN debe contener solo números."
            success = false
            return
        }

        guard new.count == 6 else {
            message = "El PIN debe tener 6 dígitos."
            success = false
            return
        }

        updatePin(new)

        message = "PIN actualizado correctamente."
        success = true

        currentPin = Array(repeating: "", count: numberOfDigits)
        newPin = Array(repeating: "", count: numberOfDigits)
        confirmPin = Array(repeating: "", count: numberOfDigits)
    }
}

#Preview {
    ChangePinView(admin: Admin.mockAdmins[0])
        .withPreviewSettings()
}
