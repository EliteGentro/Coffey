//
//  PinInputView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/10/25.
//  Edited by Augusto Orozco on 21/11/25
//

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
