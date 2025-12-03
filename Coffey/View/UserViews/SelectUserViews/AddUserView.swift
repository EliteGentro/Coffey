//
//  AddUserView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct AddUserView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var name: String = ""
    @State private var selectedCooperativa: Cooperativa?

    let cooperativas: [Cooperativa]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.beige.ignoresSafeArea()

                Form {
                    TextField("Nombre", text: $name)

                    Picker("Cooperativa", selection: $selectedCooperativa) {
                        ForEach(cooperativas, id: \.self) { coop in
                            Text(coop.name).tag(Optional(coop))
                        }
                    }

                    Button("Guardar") {
                        save()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.brown)
                }
                .navigationTitle("Agregar Usuario")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { dismiss() } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
            .onAppear {
                if selectedCooperativa == nil {
                    selectedCooperativa = cooperativas.first
                }
            }
        }
    }

    private func save() {
        guard let coop = selectedCooperativa else { return }

        let user = User(
            user_id: 0,
            name: name,
            cooperativa_id: coop.cooperativa_id,
            updatedAt: Date()
        )

        let preference = Preference(
            preference_id: nil,
            user_id: 0,
            local_user_reference: user.id,
            font_multiplier: 1.0,
            updatedAt: Date()
        )

        context.insert(user)
        context.insert(preference)

        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving:", error)
        }
    }
}

#Preview {
    // No additional NavigationStack needed — view has its own
    AddUserView(cooperativas: Cooperativa.mockCooperativas)
}
