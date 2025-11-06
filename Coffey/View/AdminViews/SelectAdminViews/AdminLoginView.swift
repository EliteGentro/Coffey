//
//  AdminLoginView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AdminLoginView: View {
    let admin: Admin
    let numberOfDigits: Int
    @Binding private var path: NavigationPath
    @State private var pin: [String]
    @FocusState private var fieldFocus: Int?
    @State private var navigateToUserSelect = false
    var onReset: () -> Void

    init(admin: Admin, numberOfDigits: Int = 6, path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self.admin = admin
        self.numberOfDigits = numberOfDigits
        _pin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        self._path = path
        self.onReset = onReset
    }
    
    private var isPinComplete: Bool {
        pin.allSatisfy { !$0.isEmpty }
    }

    var body: some View {
        VStack(spacing: 24) {
            Image("Coffee-cup")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)

            Text("Hola, \(admin.name.capitalized)")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Introduce tu PIN")
            
            // Reusable PIN input field
            PinInputView(pin: $pin, fieldFocus: _fieldFocus, numberOfDigits: numberOfDigits)
            
            Button(action: {
                print("Submitted PIN: \(pin.joined())")
                if isPinComplete {
                    navigateToUserSelect = true
                }
            }) {
                Text("Entrar")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isPinComplete ? Color.blue : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isPinComplete)
            .padding(.horizontal, 40)
            .padding(.top, 10)
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
