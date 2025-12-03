//
//  PinInputView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/10/25.
//
import SwiftUI

// MARK: - PIN Input View
struct PinInputView: View {
    @Binding var pin: [String]
    @FocusState var fieldFocus: Int?
    
    let numberOfDigits: Int
    
    // Tracks previous value for each field
    @State private var oldValue = ""
    
    var body: some View {
        HStack {
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
