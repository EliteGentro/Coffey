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
    var body: some View {
        VStack(){
            Text("Se detectó que es la primera vez se abre la aplicación. Por favor comience una sincronización con una conexión a internet")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            if(dbSync.isSynchronizing){
                ProgressView()
                Text("\(dbSync.syncProgress) %")
            } else{
                Button{
                    Task {
                        do {
                            try await dbSync.fullSynchronization(context: context)
                        } catch {
                            print("Sync error: \(error)")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                            .font(.title)
                        Text("Sincronizar")
                            .font(.largeTitle)
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            if(dbSync.isSynchronized){
                Button{
                    firstTime = false
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.title)
                        Text("Ir a Inicio")
                            .font(.largeTitle)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding(10)
        .navigationTitle("Bienvenido")
        .navigationBarTitleDisplayMode(.inline)
            }
}

#Preview {
    FirstWelcomeView()
}
