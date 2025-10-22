//
//  DetailContentUserView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct DetailContentUserView: View {
    @Environment(\.modelContext) var context
    
    @State private var showVideo = false
    
    @State private var selectedFilter: String = "Pendiente"
    @State private var progress : Progress?
    let content: Content
    let user : User
    @Query var progresses: [Progress]
    

    
    private var progressStatus: String {
        switch progress?.status ?? .notStarted {
        case .notStarted: return "Pendiente"
        case .inProgress: return "En Progreso"
        case .completed: return "Terminado"
        }
    }

    private var progressStatusIcon: String {
        switch progress?.status ?? .notStarted {
        case .notStarted: return "clock.fill"
        case .inProgress: return "progress.indicator"
        case .completed: return "checkmark.seal.fill"
        }
    }

    private var progressStatusColor: Color {
        switch progress?.status ?? .notStarted {
        case .notStarted: return .red
        case .inProgress: return .yellow
        case .completed: return .green
        }
    }


    
    
    var body: some View {
        VStack(spacing:20){
            Text(content.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(content.resourceType.capitalized)
                .font(.title)
                .font(.title)
            Text(content.details)
                .font(.body)
            
            Button(action:{
                //Play Video
                showVideo = true
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
            Button(action: {
                guard let progress else { return }

                // Toggle the status
                switch progress.status {
                case .notStarted:
                    progress.status = .inProgress
                case .inProgress:
                    progress.status = .completed
                case .completed:
                    progress.status = .notStarted
                }

                // Save the change
                do {
                    try context.save()
                } catch {
                    print("Error saving progress: \(error)")
                }
            }) {
                HStack {
                    Image(systemName: progressStatusIcon)
                        .font(.title)
                    Text(progressStatus)
                        .font(.largeTitle)
                }
                .padding()
                .background(progressStatusColor)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

        }
        .padding(40)
        .fullScreenCover(isPresented: $showVideo) {
            VideoView(content: content)
        }
        .onAppear {
            fetchOrCreateProgress()
        }
        
    }
    
    private func fetchOrCreateProgress() {
        if let existing = progresses.filter({
            $0.user_id == user.user_id && $0.content_id == content.content_id
        }).first {
            progress = existing
        } else {
            let newProgress = Progress(
                progress_id : 0,
                user_id : user.user_id,
                content_id : content.content_id,
                status: .notStarted
            )
            
            self.context.insert(newProgress)
            do{
                try self.context.save()
                progress = newProgress
                print("Saved Progress")
            } catch{
                print(error)
            }
        }
        
    }
}
    #Preview {
        DetailContentUserView(content: Content.mockContents[0], user: User.mockUsers[0])
    }
