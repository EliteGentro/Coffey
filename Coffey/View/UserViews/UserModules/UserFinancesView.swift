//
//  UserFinancesView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct UserFinancesView: View {
    let user : User
    @Query var finances: [Finance]

    @State private var selectedFinanceType : String = "Egresos"
    @State private var sortOrder = [KeyPathComparator(\Finance.date, order: .forward)]
    @State private var selectedFinance : Finance.ID? = nil
    var selectedFinanceObject: Finance? {
        finances.first(where: { $0.id == selectedFinance })
    }
    @State private var showFinanceDetail : Bool = false
    @State private var showAddFinance : Bool = false
    
    init(user: User){
        self.user = user
        let userID = user.user_id
        _finances = Query(filter: #Predicate<Finance>{ $0.user_id == userID })
        
    }
    
    let filters : [String] = ["Egresos", "Ingresos"]

    var body: some View {
        
        VStack {
            Picker("Egresos/Ingresos", selection: $selectedFinanceType) {
                ForEach(filters, id: \.self) { filter in
                    Text(filter)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Table(finances.filter {$0.type == selectedFinanceType}, selection: $selectedFinance, sortOrder: $sortOrder){
                TableColumn("Nombre", value: \.name)
                TableColumn("Categoría", value: \.category)
                TableColumn("Monto"){ finance in
                    Text("$\(String(format:"%.2f", finance.amount))")
                }
                TableColumn("Fecha"){finance in
                    Text(finance.date, style: .date)
                }
            }
            .onChange(of: selectedFinance){ oldValue, newValue in
                if(newValue != nil){
                    showFinanceDetail = true;
                }
            }
            Button(action:{
                showAddFinance = true
            }){
                HStack {
                    Image(systemName: "plus.app.fill") 
                        .font(.title)
                    Text("Agregar \(selectedFinanceType == "Egresos" ? "Egreso" : "Ingreso")")
                        .font(.largeTitle)
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .sheet(isPresented: $showFinanceDetail){
            FinanceDetailView(type: selectedFinanceType, createNew: false, finance: selectedFinanceObject)
        }
        .sheet(isPresented: $showAddFinance){
            FinanceDetailView(type: selectedFinanceType, createNew: true, finance: nil)
        }
        .navigationTitle(Text("Finanzas"))
    }
}

#Preview {
    UserFinancesView(user : User.mockUsers[0])
}
