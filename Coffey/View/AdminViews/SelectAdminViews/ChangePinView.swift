//
//  ChangePinView.swift
//  Coffey
//
//  Created by Augusto Orozco on 07/11/25.
//
//
//  ChangePinView.swift
//  Coffey

//Si revisaste esto y leiste todo este texto, saludame con otro comentario cuando hagas commit.

//Anota particularmente que cambiaste, para no perdernos y romper todo este codigo sacado de lo mas profundo de la BD de la IA. Tysm por leer esto :D

//De acuerdo con lo que investigue, puede ser que con tres focusState funcione correctamente el llenado de los campos, me falta probarlo bien dentro del simulador
//Ya que tengo la teoria de que dentro del preview no va a guardar los datos y no funcionara aunque lo intente, cuando llegue al swiftlab lo corrigo y actualizo
//El estado de este archivo en particular, generalmente el login ya funciona bien, solo falta esto para poder hacer pullrequest.

import SwiftUI
import CryptoKit
import KeychainSwift

struct ChangePinView: View {
    let admin: Admin
    let numberOfDigits: Int
    
    @State private var currentPin: [String]
    @State private var newPin: [String]
    @State private var confirmPin: [String]
    
    // 3 focus states independientes
    @FocusState private var focusCurrent: Int?
    @FocusState private var focusNew: Int?
    @FocusState private var focusConfirm: Int?
    
    @State private var message: String = ""
    @State private var success: Bool = false
    
    private let keychain = KeychainSwift()
    
    init(admin: Admin, numberOfDigits: Int = 6) {
        self.admin = admin
        self.numberOfDigits = numberOfDigits
        _currentPin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        _newPin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        _confirmPin = State(initialValue: Array(repeating: "", count: numberOfDigits))
    }
    
    // MARK: - Helper Methods
    private func hashPin(_ pin: String) -> String {
        let data = Data(pin.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func storedHashedPin() -> String? {
        keychain.get("admin_pin_\(admin.id.uuidString)")
    }
    
    private func updatePin(_ newPin: String) {
        let hashed = hashPin(newPin)
        keychain.set(hashed, forKey: "admin_pin_\(admin.id.uuidString)")
    }
    
    private func validateCurrentPin(_ pin: String) -> Bool {
        guard let stored = storedHashedPin() else { return false }
        return stored == hashPin(pin)
    }
    
    // MARK: - UI
    var body: some View {
        VStack(spacing: 24) {
            Image("Coffee-cup")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 40)
            
            Text("Cambiar PIN")
                .font(.title2)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("PIN actual")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $currentPin, fieldFocus: _focusCurrent, numberOfDigits: numberOfDigits)
                }
                
                VStack(alignment: .leading) {
                    Text("Nuevo PIN")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $newPin, fieldFocus: _focusNew, numberOfDigits: numberOfDigits)
                }
                
                VStack(alignment: .leading) {
                    Text("Confirmar nuevo PIN")
                        .font(.subheadline)
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
    
    // MARK: - Logic
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
        
        updatePin(new)
        message = "PIN actualizado correctamente."
        success = true
        
        // Limpia los campos después de éxito
        currentPin = Array(repeating: "", count: numberOfDigits)
        newPin = Array(repeating: "", count: numberOfDigits)
        confirmPin = Array(repeating: "", count: numberOfDigits)
    }
}

#Preview {
    ChangePinView(admin: Admin.mockAdmins[0])
}
