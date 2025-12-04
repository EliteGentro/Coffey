//
//  UserDetailProfileView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//
import SwiftUI
import SwiftData

struct UserDetailProfileView: View {
    // The user whose details will be displayed
    let user: User
    @Query private var progresses: [Progress]
    @Query private var finances: [Finance]
    @Query private var cooperativas: [Cooperativa]
    @StateObject private var userVM = UserViewModel()
    
    var body: some View {
        ZStack{
            BackgroundView()
        ScrollView {
        VStack(spacing: 40) {
            // Profile circle showing user's initials
            InitialProfileCircleView(name: user.name)
            
            // User's full name displayed prominently
            Text(user.name)
                .font(Font.largeTitle.bold())

            
            // MARK: - Progress Gauges
            VStack(spacing: 24) {
                // Average Grade Gauge
                VStack(alignment: .center, spacing: 12) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                            .foregroundColor(.blue)
                        Text("Promedio de Calificaciones")
                            .font(.headline)
                    }
                    
                    let avgGrade = userVM.getAverageGrade(for: user, progresses: progresses)
                    Gauge(value: avgGrade, in: 0...100) {
                        Text("Promedio")
                    } currentValueLabel: {
                        Text("\(Int(avgGrade))")
                            .font(.title2.bold())
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(avgGrade >= 70 ? .green : avgGrade >= 50 ? .yellow : .red)
                    
                    Text("Promedio de los Cursos Completados")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassCard()
                
                // Completion Rate Gauge
                VStack(alignment: .center, spacing: 12) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Tasa de Finalización")
                            .font(.headline)
                    }
                    
                    let completionRate = userVM.getCompletionRate(for: user, progresses: progresses)
                    let completedCount = userVM.getContenidosTerminados(for: user, progresses: progresses)
                    let totalCount = progresses.filter { progress in
                        user.user_id == 0 ?
                            progress.local_user_reference == user.id :
                            progress.user_id == user.user_id
                    }.count
                    
                    Gauge(value: completionRate, in: 0...1) {
                        Text("Progreso")
                    } currentValueLabel: {
                        Text("\(Int(completionRate * 100))%")
                            .font(.title2.bold())
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.blue)
                    
                    Text("\(completedCount) de \(totalCount) cursos completados")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassCard()
                
                // Financial Balance Gauge
                VStack(alignment: .center, spacing: 12) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.purple)
                        Text("Balance Financiero")
                            .font(.headline)
                    }
                    
                    let financialBalance = userVM.getFinancialBalance(for: user, finances: finances)
                    
                    if(financialBalance > 0){
                        
                    
                    Gauge(value: financialBalance, in: 0...1) {
                        Text("Balance")
                    } currentValueLabel: {
                        VStack(spacing: 4) {
                            Image(systemName: financialBalance >= 0.5 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                .foregroundColor(financialBalance >= 0.5 ? .green : .red)
                            Text("\(Int(financialBalance * 100))%")
                                .font(.title3.bold())
                        }
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(financialBalance >= 0.5 ? .green : .red)
                    
                    Text(financialBalance >= 0.5 ? "Más ingresos que egresos" : "Más egresos que ingresos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    } else{
                        Text("No se han registrado Finanzas")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .glassCard()
            }
            
            // MARK: - Basic Info Card
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.brown)
                    Text("Cooperativa:")
                        .font(.headline)
                    Spacer()
                    Text(userVM.getCooperativa(for: user, cooperativas: cooperativas)?.name ?? "Sin Cooperativa")
                        .font(.title3)
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.blue)
                    Text("Contenidos Totales:")
                        .font(.headline)
                    Spacer()
                    Text("\(userVM.getContenidosTerminados(for: user, progresses: progresses))")
                        .font(.title3)
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Puntaje Total:")
                        .font(.headline)
                    Spacer()
                    Text("\(userVM.getPuntajeAprendizaje(for: user, progresses: progresses))")
                        .font(.title3)
                }
            }
            .padding()
            .glassCard()
        }
        .padding()
        }
        }
    }
}

#Preview {
    // No NavigationStack needed — this view has no NavigationLinks
    UserDetailProfileView(user: User.mockUsers[1])
}
