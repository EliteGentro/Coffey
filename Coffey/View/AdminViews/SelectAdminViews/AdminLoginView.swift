//
//  AdminLoginView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//  Edited By Augusto Orozco on 07/11/25.
//

import SwiftUI
import CryptoKit // Para cifrado
import KeychainSwift //Para guardar el pin

struct AdminLoginView: View {
    let admin: Admin
    let numberOfDigits: Int
    @Binding private var path: NavigationPath
    @State private var pin: [String]
    @FocusState private var fieldFocus: Int?
    @State private var navigateToUserSelect = false
    @State private var message: String = ""
    @State private var success: Bool = false
    var onReset: () -> Void

    private let keychain = KeychainSwift() //Verificar aca

    init(admin: Admin, numberOfDigits: Int = 6, path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self.admin = admin
        self.numberOfDigits = numberOfDigits
        _pin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        self._path = path
        self.onReset = onReset
    }
    
    private var isPinComplete: Bool { //Segun yo este funciona
        pin.allSatisfy { !$0.isEmpty }
    }

    private var isPinNumeric: Bool { //Segun yo este tmb funciona
        pin.joined().allSatisfy { $0.isNumber }
    }

    //Posiblemente cifrar el pin usando SHA256
    private func hashPin(_ pin: String) -> String {
        let data = Data(pin.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    private func saveHashedPIN(_ pin: String) {
        let hashed = hashPin(pin)
        keychain.set(hashed, forKey: "admin_\(admin.id.uuidString)_pin") //Verificar lo del Admin.id
    }

    private func validatePIN(_ pin: String) -> Bool {
        let hashed = hashPin(pin)
        if let stored = keychain.get("admin_\(admin.id.uuidString)_pin") { //Verificar lo del Admin.id
            return stored == hashed
        } else {
            saveHashedPIN(pin)
            return true // Primer inicio, se guarda el PIN
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Image("coffee-cup")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Hola, \(admin.name.capitalized)")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Introduce tu PIN")

            //Me acabo de dar cuenta que no valida un pin, solo asume que ya hay uno, hay que corregir eso.

            //Explicar aca como funciona el proceso de guardado y validacion del pin, creo que se guarda al primer inicio, luego se valida cada vez que se ingresa
            //Si es asi, esta todo bien, y funciona. (Aprovado: Funciona)

            // Reusable PIN input field
            PinInputView(pin: $pin, fieldFocus: _fieldFocus, numberOfDigits: numberOfDigits)
            
            Button(action: { //Todo lo de aca es para verificar si el pin es numerico, sean 6 digitos y si el pin es correcto
                let enteredPin = pin.joined()
                print("Submitted PIN: \(enteredPin)")

                guard isPinNumeric else {
                    message = "El PIN debe ser numérico."
                    success = false
                    return
                }

                //Este por el es inutil por ahora, posiblemente lo quite.
                
                guard isPinComplete else {
                    message = "El Pin esta incompleto"
                    success = false
                    return
                }
                
                guard validatePIN(enteredPin) else {
                    message = "PIN incorrecto."
                    success = false
                    return
                }
                message = ""
                success = true
                navigateToUserSelect = true
            }) {
                Text("Entrar")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isPinComplete ? Color.brown : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isPinComplete)
            .padding(.horizontal, 40)
            .padding(.top, 10)

            // Aca iria el cambio de PIN, falta crear la otra vista del cambio de pin, y validar si funciona, esto podria ser otro test (Creada y funcionando)
            NavigationLink {
                ChangePinView(admin: admin)
            } label: {
                Text("Cambiar PIN")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .padding(.top, 8)
            }
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(success ? .green : .red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
        .navigationDestination(isPresented: $navigateToUserSelect) {
            SelectAdminModeView(path: $path, onReset: onReset)
        }
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    NavigationStack {
        AdminLoginView(admin: Admin.mockAdmins[0], path: $dummyPath)
    }
}
