//
//  AdminLoginView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AdminLoginView: View {
    let admin: Admin
    let numberOfDigits : Int
    
    @State private var pin: [String]
    @State private var oldValue = ""
    @FocusState private var fieldFocus : Int?
    
    init(admin: Admin, numberOfDigits: Int = 6) {
            self.admin = admin
            self.numberOfDigits = numberOfDigits
            _pin = State(initialValue: Array(repeating: "", count: numberOfDigits))
        }
    private var isPinComplete: Bool {
        pin.allSatisfy { !$0.isEmpty }
    }
    
    var body: some View {
        VStack(spacing:24){
            Text("Hola, \(admin.name.capitalized)")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack{
                ForEach(0..<numberOfDigits, id:\.self){ index in
                    TextField("",text: $pin[index], onEditingChanged:
                    { editing in
                        if editing{
                            oldValue = pin[index]
                        }
                    })
                        .keyboardType(.numberPad)
                        .frame(width:40,height:50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                        .multilineTextAlignment(.center)
                        .focused($fieldFocus, equals:index)
                        .tag(index)
                        .onChange(of: pin[index]){ oldValue, newValue in
                            if pin[index].count > 1{
                                let currentValue = Array(pin[index])
                                
                                if currentValue[0] == Character(oldValue){
                                    pin[index] =
                                    String(pin[index].suffix(1))
                                } else{
                                    pin[index] =
                                    String(pin[index].prefix(1))
                                }
                                
                            }
                            if !newValue.isEmpty {
                                if index==numberOfDigits-1 {
                                    fieldFocus = nil
                                } else{
                                    fieldFocus = (fieldFocus ?? 0) + 1
                                }
                            } else{
                                fieldFocus = (fieldFocus ?? 0) - 1
                            }
                           
                        }
                }
            }
            .padding()
            Button(action: {
                        print("Submitted PIN: \(pin.joined())")
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
    }
}



#Preview {
    AdminLoginView(admin:Admin(name: "humberto", cooperativa_id: "1", password: "1"))
}
