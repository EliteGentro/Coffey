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
    
    @State private var navigateToQuiz = false
    @State private var showVideo = false
    @State private var showPDF = false
    @StateObject private var quizVM = QuizViewModel()
    @State private var selectedFilter: String = "Pendiente"
    @State private var progress : Progress?
    let content: Content
    let user : User
    @State private var progresses: [Progress] = []
    

    
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
            if(quizVM.isQuizComplete){
                Text("Calificación: \(quizVM.correctCount*20)")
                    .font(.title2.bold())
                
                Text("Respondiste correctamente a \(quizVM.correctCount) de \(quizVM.quiz?.questions.count ?? 0) preguntas 🎉")
                    .font(.title3)
            }
            Text(content.resourceType.capitalized)
                .font(.title)
                .font(.title)
            Text(content.details)
                .font(.body)
            
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
            Button {
                Task {
                    try? await quizVM.generateQuiz(content: content)
                    
                }
            } label: {
                if quizVM.isLoading {
                    ProgressView()
                } else {
                    Text("Realizar Quiz")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.gradient)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
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
        .fullScreenCover(isPresented: $showPDF) {
            PDFKitView(content: content)
        }
        .onAppear {
            fetchOrCreateProgress()
        }
        .sheet(isPresented: $quizVM.isDone) {
            QuestionView(vm : quizVM)
                .presentationDetents([.large])
        }
        
    }
    
    private func fetchOrCreateProgress() {
        do {
            let userID = user.user_id
            let localID = user.id
            let contentID = content.content_id
            print(userID)
            print(localID)
            //  Split into two smaller filters
            
            
            let byUser : Predicate<Progress>
            if(userID == 0){
                byUser = #Predicate<Progress> { $0.local_user_reference == localID }
            } else{
                byUser  = #Predicate<Progress> { $0.user_id == userID }
            }

            let byContent = #Predicate<Progress> { $0.content_id == contentID }
            
            let combinedPredicate = #Predicate<Progress> { progress in byUser.evaluate(progress) && byContent.evaluate(progress)
            }
            
            let descriptor = FetchDescriptor<Progress>(predicate: combinedPredicate)
            if let existing = try context.fetch(descriptor).first {
                progress = existing
            } else {
                let newProgress = Progress(
                    progress_id: 0,
                    user_id: userID,
                    content_id: contentID,
                    grade: 0,
                    status: .notStarted,
                    local_user_reference: user.id
                )
                context.insert(newProgress)
                try context.save()
                progress = newProgress
                print("Saved Progress")
            }
        } catch {
            print("Error fetching or saving progress:", error)
        }
    }
}
    #Preview {
        DetailContentUserView(content: Content.mockContents[0], user: User.mockUsers[0])
    }
