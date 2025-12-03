
//
//  FinanceDetailView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct FinanceDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    let type: String
    let createNew: Bool
    let user : User?
    let finance: Finance?
    
    @State private var name: String
    @State private var amount: Double
    @State private var selectedCategory: String
    private let categoryOptions: [String] = ["Hogar", "Personal", "Trabajo"]
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    
    init(type: String, createNew: Bool, finance: Finance? = nil, user: User? = nil) {
        self.type = type
        self.createNew = createNew
        self.finance = finance
        self.user = user
        
        _name = State(initialValue: finance?.name ?? "")
        _amount = State(initialValue: finance?.amount ?? 0.0)
        _selectedCategory = State(initialValue: finance?.category ?? "Hogar")
    }
    
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
        VStack{
            Form {
                // Text field for user name
                TextField("Nombre", text: $name)
                
                // Picker to select cooperativa
                Picker("Categoría", selection: $selectedCategory) {
                    ForEach(categoryOptions, id: \.self) { option in
                        Text(option)
                    }
                }
                
                TextField("Cantidad", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                
                // Save button (functionality to be implemented)
                HStack{
                    Spacer()
                    Button() {
                        if(createNew){
                            let finance = Finance(
                                finance_id: 0,
                                user_id: user?.user_id ?? 0,
                                name: self.name,
                                date: Date(),
                                category: self.selectedCategory,
                                amount: self.amount,
                                type: self.type,
                                local_user_reference: user?.id ?? UUID(),
                                updatedAt: Date()
                            )
                            
                            self.context.insert(finance)
                        } else if let finance{
                            finance.name = self.name
                            finance.amount = self.amount
                            finance.category = self.selectedCategory
                            finance.updatedAt = Date()
                        }
                        
                        do{
                            try self.context.save()
                            dismiss()
                        } catch{
                            errorMessage = "Error al guardar: \(error.localizedDescription)"
                            showErrorAlert = true
                        }
                    } label:  {
                        HStack {
                            Image(systemName: createNew ? "plus" : "square.and.arrow.down")
                                .font(.title2)
                            
                            Text(createNew ? "Agregar" : "Guardar")
                                .font(.title2.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    Spacer()
                }
            }
            if(!createNew){
                Button(action:{
                    finance!.deletedAt = Date()
                    do{
                        try self.context.save()
                        dismiss()
                    } catch{
                        errorMessage = "Error al borrar: \(error.localizedDescription)"
                        showErrorAlert = true
                    }
                })
                {
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.title2)
                        
                        Text("Borrar")
                            .font(.title2.bold())
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
        }
        .padding(40)
        .navigationTitle(createNew ? "Agregar \(type.prefix(type.count - 1))" : "Editar \(type.prefix(type.count - 1))")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        // Toolbar with dismiss button
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
    FinanceDetailView(type: Finance.mockFinances[0].type, createNew: true, finance: nil)
}
