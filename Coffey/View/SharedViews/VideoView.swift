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
            ZStack(alignment: .topTrailing) {
                VideoPlayer(player: player)
                    .ignoresSafeArea()

                // Close button overlay
                Button(action: {
                    player.pause()
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding()
                }
            }
            .onAppear {
                print("Name \(content.name)")
                if let playerItem = downloadManager.getVideoFileAsset(content: content) {
                    player = AVPlayer(playerItem: playerItem)
                    player.play()
                }
            }
            .onDisappear {
                player.pause()
            }
        }
}
