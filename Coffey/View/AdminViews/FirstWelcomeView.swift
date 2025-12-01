//
//  FirstWelcomeView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 20/11/25.
//

import SwiftUI

struct FirstWelcomeView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dbSync = DBSynchronizer()
    @AppStorage("firstTime") var firstTime: Bool = true
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
            VStack(spacing: 28) {
                
                // MARK: - Title + Instructions
                VStack(spacing: 16) {
                    Text("Bienvenido")
                        .scaledFont(.largeTitle.bold())
                    
                    Text("Es la primera vez que se abre la aplicación. Para comenzar, sincronice los datos con una conexión a Internet.")
                        .scaledFont(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                
                // MARK: - Sync Status
                if dbSync.isSynchronizing {
                    VStack(spacing: 12) {
                        ProgressView(value: Double(dbSync.syncProgress), total: 100)
                            .padding(.horizontal)
                        
                        Text("Sincronizando... \(dbSync.syncProgress)%")
                            .scaledFont(.headline)
                    }
                    
                } else {
                    // MARK: - Sync Button
                    Button {
                        Task {
                            do {
                                try await dbSync.fullSynchronization(context: context)
                            } catch {
                                errorMessage = "\(error)"
                                showErrorAlert = true
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                .scaledFont(.title2)
                            
                            Text("Sincronizar")
                                .scaledFont(.title2.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(dbSync.isSynchronizing)
                    .opacity(dbSync.isSynchronizing ? 0.6 : 1)
                }
                
                
                // MARK: - Continue Button
                if dbSync.isSynchronized {
                    Button {
                        firstTime = false
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                                .scaledFont(.title2)
                            
                            Text("Ir a Inicio")
                                .scaledFont(.title2.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                
            }
            .padding(20)
            .navigationTitle("Bienvenido")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error: Revise su Conexión", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        }
}

#Preview {
    FirstWelcomeView()
}
