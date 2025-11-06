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
        VStack(spacing:20){
            Text(content.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(content.resourceType.capitalized)
                .font(.title)
            Link("Link:", destination: URL(string: content.url)!)
                .font(.title)
            Text(content.details)
                .font(.body)
            
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
                        .background(Color.green)
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
                            .font(.title)
                        Text("Ver")
                            .font(.largeTitle)
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                Button(action:{
                    //Delete File
                    downloadManager.deleteFile(content: content)
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
        .fullScreenCover(isPresented: $showVideo) {
            VideoView(content: content)
        }
        .fullScreenCover(isPresented: $showPDF) {
            PDFKitView(content: content)
        }
        
    }
}

#Preview {
    let container = try! ModelContainer(for: Content.self)
    let mockManager = DownloadManager(modelContainer: container)
    
    ContentDetailAdminView(content: Content.mockContents.first!)
        .environmentObject(mockManager)
        
}
