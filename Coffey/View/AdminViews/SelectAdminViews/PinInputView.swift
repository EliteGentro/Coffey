//
//  PinInputView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/10/25.
//  Edited by Augusto Orozco on 21/11/25
//

import SwiftUI

// MARK: - UITextField con detección de deleteBackward
class PinTextField: UITextField {
    var onDelete: (() -> Void)?
    
    override func deleteBackward() {
        onDelete?()
        super.deleteBackward()
    }
}

// MARK: - Wrapper para usar PinTextField en SwiftUI
struct PinDigitField: UIViewRepresentable {
    
    @Binding var text: String
    var onDelete: (() -> Void)
    
    func makeUIView(context: Context) -> PinTextField {
        let view = PinTextField()
        view.keyboardType = .numbersAndPunctuation
        view.textAlignment = .center
        view.onDelete = {
            if view.text?.isEmpty == true {
                onDelete()
            }
        }
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: PinTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PinDigitField
        
        init(_ parent: PinDigitField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            
            if string.isEmpty { // borrar
                parent.text = ""
                return false
            }
            
            // aceptar solo 1 carácter
            if parent.text.isEmpty {
                parent.text = string
            }
            
            return false
        }
    }
}

struct PinInputView: View {

    @Binding var pin: [String]
    @FocusState private var focusIndex: Int?

    let numberOfDigits: Int

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<numberOfDigits, id: \.self) { index in
                PinDigitField(text: $pin[index], onDelete: {
                    if index > 0 {
                        pin[index] = ""
                        focusIndex = index - 1
                    }
                })
                .frame(width: 40, height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .focused($focusIndex, equals: index)
                .onChange(of: pin[index]) { newValue in
                    // Mantener solo 1 carácter
                    if newValue.count > 1 {
                        pin[index] = String(newValue.prefix(1))
                    }

                    // Avanzar al siguiente campo si se ingresó un carácter
                    if !newValue.isEmpty && index < numberOfDigits - 1 {
                        focusIndex = index + 1
                    }
                }
            }
        }
        .padding()
        .onAppear {
            // Enfocar el primer campo al iniciar
            focusIndex = 0
        }
    }
}
