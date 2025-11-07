//
//  ChangePinView.swift
//  Coffey
//
//  Created by Alumno on 07/11/25.
//

//
//  ChangePinView.swift
//  Coffey
//

import SwiftUI
import CryptoKit
import KeychainSwift

struct ChangePinView: View {
    let admin: Admin
    let numberOfDigits: Int
    
    @State private var currentPin: [String]
    @State private var newPin: [String]
    @State private var confirmPin: [String]
    @FocusState private var fieldFocus: Int?
    
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
        keychain.get("admin_pin_\(admin.id.uuidString ?? "unknown")")
    }
    
    private func updatePin(_ newPin: String) {
        let hashed = hashPin(newPin)
        keychain.set(hashed, forKey: "admin_pin_\(admin.id.uuidString ?? "unknown")")
    }
    
    private func validateCurrentPin(_ pin: String) -> Bool {
        guard let stored = storedHashedPin() else { return false }
        return stored == hashPin(pin)
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack(spacing: 24) {
            // Imagen superior coherente con AdminLoginView
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
                    PinInputView(pin: $currentPin, fieldFocus: _fieldFocus, numberOfDigits: numberOfDigits)
                }
                
                VStack(alignment: .leading) {
                    Text("Nuevo PIN")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $newPin, fieldFocus: _fieldFocus, numberOfDigits: numberOfDigits)
                }
                
                VStack(alignment: .leading) {
                    Text("Confirmar nuevo PIN")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    PinInputView(pin: $confirmPin, fieldFocus: _fieldFocus, numberOfDigits: numberOfDigits)
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
