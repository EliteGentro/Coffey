//
//  AddUserView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var confirmPassword: String = ""
    @State private var selectedCooperativa = "Cooperativa1"
    @State private var cooperativa_options: [String] = ["Cooperativa1", "Cooperativa2", "Cooperativa3", "Cooperativa4"]
    
    @State private var showPasswordMismatchAlert: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nombre", text: $name)

                Picker("Cooperativa", selection: $selectedCooperativa) {
                    ForEach(cooperativa_options, id: \.self) { option in
                        Text(option)
                    }
                }

                Button("Guardar") {
                    
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Agregar Usuario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}


#Preview {
    AddUserView()
}
