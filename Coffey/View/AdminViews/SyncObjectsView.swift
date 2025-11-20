//
//  SyncObjects.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 20/11/25.
//

import SwiftUI

struct SyncObjectsView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var dbSync = DBSynchronizer()
    
    var body: some View {
        VStack{
            if(dbSync.isSynchronizing){
                ProgressView()
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
            Text("Es necesario tener una conexión a internet para poder sincronizar los contenidos. No salgas de la aplicación hasta que esta finalice.")
                .font(Font.largeTitle.bold())
        }
        
    }
}

#Preview {
    SyncObjectsView()
}
