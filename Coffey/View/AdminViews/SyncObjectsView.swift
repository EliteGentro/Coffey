//
//  SyncObjects.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 20/11/25.
//

import SwiftUI

struct SyncObjectsView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @StateObject private var dbSync = DBSynchronizer()
    // State for showing leave alert
    @State private var showLeaveAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
        VStack{
            if(dbSync.isSynchronizing){
                ProgressView()
            } else{
                Button{
                    Task {
                        do {
                            try await dbSync.fullSynchronization(context: context)
                        } catch {
                            showErrorAlert = true
                            errorMessage = "\(error)"
                            print("Sync error: \(error)")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                            .scaledFont(.title)
                        Text("Sincronizar")
                            .scaledFont(.largeTitle)
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            Text("Es necesario tener una conexión a internet para poder sincronizar los contenidos. No podrás salir de la aplicación hasta que esta finalice.")
                .scaledFont(.largeTitle).bold()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if(!dbSync.isSynchronized){
                        showLeaveAlert = true
                    } else{
                        dismiss()
                    }

                }) {
                    Image(systemName: "chevron.left")
                }
                .disabled(dbSync.isSynchronizing)
            }
        }
        // Alert confirmation for leaving
        .alert("¿Seguro que quieres salir?", isPresented: $showLeaveAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Confirmar", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("No hiciste ninguna sincronización de datos")
        }
        .alert("Error: Revise su Conexión", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
        .padding(50)
        
        }
    }
}

#Preview {
    SyncObjectsView()
}
