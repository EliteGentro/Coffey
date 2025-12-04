//
//  ContentDetailAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 21/10/25.
//

//ONLY WORKS With VIDEOS RIGHT NOW

import SwiftUI
import SwiftData

struct ContentDetailAdminView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var downloadManager: DownloadManager
    
    @State private var showVideo = false
    @State private var showPDF = false

    
    
    let content : Content
    
    var body: some View {
        ZStack{
            BackgroundView()
        ScrollView{
            VStack(spacing:20){
                // MARK: Title
                Text(content.name)
                    .font(.largeTitle.bold())
                
                // MARK: Resource Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.resourceType.capitalized)
                        .font(.headline)
                    Link("Vista Previa", destination: URL(string: content.url)!)
                        .font(.headline)
                    Text(content.details)
                        .font(.body)
                }
                .padding()
                .glassCard()

                
                if(!content.isDownloaded){
                    if(downloadManager.isDownloading(content)){
                        ProgressView()
                    }else{
                        Button(action:{
                            //Download File
                            downloadManager.downloadFile(content: content)
                        }){
                            HStack {
                                Image(systemName: "arrow.down.circle.fill")
                                    .font(.title)
                                Text("Descargar")
                                    .font(.largeTitle)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                } else{
                    Button(action:{
                        
                        //Play Video
                        if content.resourceType == "video" {
                            showVideo = true
                        } else{
                            showPDF = true
                        }
                    }){
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.title2)
                            Text("Ver")
                                .font(.title3.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    Button(action:{
                        //Delete File
                        downloadManager.deleteFile(content: content)
                    }){
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.title2)
                            Text("Borrar")
                                .font(.title3.bold())
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
            }
            .padding(40)
            .fullScreenCover(isPresented: $showVideo) {
                VideoView(content: content)
            }
            .fullScreenCover(isPresented: $showPDF) {
                PDFKitView(content: content)
            }
        }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Content.self)
    let mockManager = DownloadManager(modelContainer: container)
    
    ContentDetailAdminView(content: Content.mockContents.first!)
        .environmentObject(mockManager)
        
}
