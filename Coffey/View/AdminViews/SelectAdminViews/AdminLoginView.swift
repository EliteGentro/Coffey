//
//  AdminLoginView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//  Edited By Augusto Orozco on 07/11/25.
//

import SwiftUI
import CommonCrypto

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

    init(admin: Admin, numberOfDigits: Int = 6, path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self.admin = admin
        self.numberOfDigits = numberOfDigits
        _pin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        self._path = path
        self.onReset = onReset
    }

    // MARK: - PIN validation helpers
    private var isPinComplete: Bool {
        pin.allSatisfy { !$0.isEmpty }
    }

    private var isPinNumeric: Bool {
        pin.joined().allSatisfy { $0.isNumber }
    }

    // MARK: - Validation against BD
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

    var body: some View {
        ZStack {
            Color.beige.ignoresSafeArea()

            VStack(spacing: 24) {
                Image("coffee-cup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Text("Hola, \(admin.name.capitalized)")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Introduce tu PIN")

                // PIN input view
                PinInputView(pin: $pin, numberOfDigits: numberOfDigits)

                // MARK: - Login button
                Button {
                    let enteredPin = pin.joined()

                    guard isPinNumeric else {
                        message = "El PIN debe ser numérico."
                        success = false
                        return
                    }

                    guard isPinComplete else {
                        message = "El PIN está incompleto."
                        success = false
                        return
                    }

                    guard validateCurrentPin(enteredPin) else {
                        message = "PIN incorrecto."
                        success = false
                        return
                    }

                    message = ""
                    success = true
                    navigateToUserSelect = true

                } label: {
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
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    NavigationStack {
        AdminLoginView(admin: Admin.mockAdmins[0], path: $dummyPath)
    }
}
