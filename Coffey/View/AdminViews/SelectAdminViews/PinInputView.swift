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

// MARK: - Vista de PIN completa
struct PinInputView: View {

    @Binding var pin: [String]
    @FocusState private var focusIndex: Int?

    let numberOfDigits: Int

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<numberOfDigits, id: \.self) { index in
                TextField("", text: $pin[index], onEditingChanged: { editing in
                    if editing {
                        oldValue = pin[index]
                    }
                })
                .keyboardType(.numbersAndPunctuation)
                .frame(width: 40, height: 50)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
                .multilineTextAlignment(.center)
                .focused($fieldFocus, equals: index)
                .tag(index)
                .onChange(of: pin[index]) { oldValue,newValue in
                    // Ensure only a single character per field
                    if pin[index].count > 1 {
                        let chars = Array(pin[index])
                        if chars[0] == Character(oldValue) {
                            pin[index] = String(chars.suffix(1))
                        } else {
                            pin[index] = String(chars.prefix(1))
                        }
                    }

                    // Move focus (async prevents UIKit keyboard conflicts)
                    if !newValue.isEmpty {
                        DispatchQueue.main.async {
                            if index < numberOfDigits - 1 {
                                fieldFocus = index + 1
                            } else {
                                fieldFocus = nil
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            if index > 0 {
                                fieldFocus = index - 1
                            }
                        }
                    }
                }

            }
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var pinArray = Array(repeating: "", count: 6)
    PinInputView(pin: $pinArray, numberOfDigits: 6)
}
