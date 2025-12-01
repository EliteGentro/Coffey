//
//  UserFinancesView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct UserFinancesView: View {
    let user: User
    @Query var finances: [Finance]

    @State private var selectedFinanceType: String = "Egresos"
    @State private var sortOrder = [KeyPathComparator(\Finance.date, order: .forward)]
    @State private var selectedFinance: Finance.ID? = nil
    var selectedFinanceObject: Finance? {
        finances.first(where: { $0.id == selectedFinance })
    }

    @State private var showFinanceDetail = false
    @State private var showAddFinance = false
    @State private var showReceiptScanner = false
    @State private var importedFinance: Finance? = nil
    @State private var createNewFinance = false

    private let filters = ["Egresos", "Ingresos"]

    init(user: User) {
        self.user = user
        let userID = user.user_id
        _finances = Query(filter: #Predicate<Finance> { $0.user_id == userID  && $0.deletedAt == nil})
    }

    private let columns: [GridItem] = [
        .init(.flexible(minimum: 80)),
        .init(.flexible(minimum: 80)),
        .init(.flexible(minimum: 60)),
        .init(.flexible(minimum: 80))
    ]

    var body: some View {
        ZStack {
            Color.beige.ignoresSafeArea()

            VStack {

                // MARK: Picker
                Picker("Egresos/Ingresos", selection: $selectedFinanceType) {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // MARK: Header
                LazyVGrid(columns: columns, spacing: 12) {
                    Text("Nombre").bold()
                    Text("Categoría").bold()
                    Text("Monto").bold()
                    Text("Fecha").bold()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                // MARK: Scrollable Grid with Max Height
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Array(filteredFinances.enumerated()), id: \.element.id) { index, finance in

                            let rowBackground = index.isMultiple(of: 2)
                            ? Color.white.opacity(0.05)
                            : Color.clear

                            // Cell 1
                            Text(finance.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                                .background(rowBackground)
                                .contentShape(Rectangle())
                                .onTapGesture { rowTapped(finance) }

                            // Cell 2
                            Text(finance.category)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                                .background(rowBackground)
                                .contentShape(Rectangle())
                                .onTapGesture { rowTapped(finance) }

                            // Cell 3
                            Text("$\(finance.amount, specifier: "%.2f")")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.vertical, 10)
                                .background(rowBackground)
                                .contentShape(Rectangle())
                                .onTapGesture { rowTapped(finance) }

                            // Cell 4
                            Text(finance.date, style: .date)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.vertical, 10)
                                .background(rowBackground)
                                .contentShape(Rectangle())
                                .onTapGesture { rowTapped(finance) }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .frame(maxHeight: 350) // max height -> scrollable

                Spacer().frame(height: 12)

                // MARK: Buttons
                Button {
                    showAddFinance = true
                } label: {
                    HStack {
                        Image(systemName: "plus.app.fill").font(.title)
                        Text("Agregar \(selectedFinanceType == "Egresos" ? "Egreso" : "Ingreso")")
                            .font(.title2).bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }

                if selectedFinanceType == "Egresos" {
                    Button {
                        showReceiptScanner = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.app.fill").font(.title)
                            Text("Agregar Egreso por recibo")
                                .font(.title2).bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.brown)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }

            // MARK: Sheet Logic (Unchanged)
            .onChange(of: selectedFinance) { oldValue, newValue in
                if newValue != nil {
                    createNewFinance = false
                    importedFinance = nil
                    showFinanceDetail = true
                }
            }
            .sheet(isPresented: $showFinanceDetail) {
                FinanceDetailView(
                    type: importedFinance?.type ?? selectedFinanceType,
                    createNew: createNewFinance,
                    finance: importedFinance ?? selectedFinanceObject,
                    user: user
                )
                .onDisappear { importedFinance = nil }
            }
            .sheet(isPresented: $showAddFinance) {
                FinanceDetailView(
                    type: selectedFinanceType,
                    createNew: true,
                    finance: nil,
                    user: user
                )
            }
            .sheet(isPresented: $showReceiptScanner) {
                ReceiptScannerView(user: user) { finance in
                    importedFinance = finance
                    showReceiptScanner = false
                    createNewFinance = true

                    DispatchQueue.main.async {
                        showFinanceDetail = true
                    }
                }
            }
            .navigationTitle("Finanzas")
        }
    }

    // MARK: Helpers

    private var filteredFinances: [Finance] {
        finances.filter { $0.type == selectedFinanceType }
    }

    private func rowTapped(_ finance: Finance) {
        createNewFinance = false
        importedFinance = nil
        selectedFinance = finance.id
        showFinanceDetail = true
    }
}

#Preview {
    UserFinancesView(user: User.mockUsers[0])
}
