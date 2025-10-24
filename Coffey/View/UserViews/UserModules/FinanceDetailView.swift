
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
                    Button(createNew ? "Agregar":"Guardar") {
                        if(createNew){
                            let finance = Finance(
                                finance_id: 0,
                                user_id: user?.user_id ?? 0,
                                name: self.name,
                                date: Date(),
                                category: self.selectedCategory,
                                amount: self.amount,
                                type: self.type,
                                local_user_reference: user?.id ?? UUID()
                            )
                            
                            self.context.insert(finance)
                        } else if let finance{
                            finance.name = self.name
                            finance.amount = self.amount
                            finance.category = self.selectedCategory
                        }
                        
                        do{
                            try self.context.save()
                        } catch{
                            print(error)
                        }
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
            }
            if(!createNew){
                Button(action:{
                    context.delete(finance!)
                    do{
                        try self.context.save()
                    } catch{
                        print(error)
                    }
                    dismiss()
                }){
                    HStack {
                        Image(systemName: "trash.fill")
                            .font(.title)
                        Text("Borrar")
                            .font(.largeTitle)
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(40)
        .navigationTitle(createNew ? "Agregar \(type.prefix(type.count - 1))" : "Editar \(type.prefix(type.count - 1))")
        .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    FinanceDetailView(type: Finance.mockFinances[0].type, createNew: true, finance: nil)
}
