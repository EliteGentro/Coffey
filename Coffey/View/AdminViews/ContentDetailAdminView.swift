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
            Color.beige.ignoresSafeArea()
        ScrollView{
            VStack(spacing:20){
                // MARK: Title
                Text(content.name)
                    .scaledFont(.largeTitle.bold())
                
                // MARK: Resource Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.resourceType.capitalized)
                        .scaledFont(.headline)
                    Link("Vista Previa", destination: URL(string: content.url)!)
                        .scaledFont(.headline)
                    Text(content.details)
                        .scaledFont(.body)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

                
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
                                    .scaledFont(.title)
                                Text("Descargar")
                                    .scaledFont(.largeTitle)
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
                                .scaledFont(.title2)
                            Text("Ver")
                                .scaledFont(.title3.bold())
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
                                .scaledFont(.title2)
                            Text("Borrar")
                                .scaledFont(.title3.bold())
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
