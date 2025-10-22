//
//  VideoView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 21/10/25.
//
import SwiftUI
import AVKit
import SwiftData

struct VideoView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var downloadManager: DownloadManager
    @State var player = AVPlayer()
    let content : Content
    
    var body: some View {
        VideoPlayer(player: player)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                print("Name \(content.name)")
                let playerItem = downloadManager.getVideoFileAsset(content: self.content)
                if let playerItem = playerItem {
                    player = AVPlayer(playerItem: playerItem)
                }
                player.play()
            }
    }
}
