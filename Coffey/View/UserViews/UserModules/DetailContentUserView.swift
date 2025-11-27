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
    @State private var showQuiz = false
    @StateObject private var quizVM = QuizViewModel()
    @State private var selectedFilter: String = "Pendiente"
    @State private var progress : Progress?
    let content: Content
    let user : User
    @State private var progresses: [Progress] = []
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    
    
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
        ZStack{
            Color.beige.ignoresSafeArea()
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                
                // MARK: Title
                Text(content.name)
                    .font(.largeTitle.bold())
                
                // MARK: Quiz Results
                if quizVM.isQuizComplete {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calificación: \(quizVM.correctCount * 20)")
                            .font(.title2.bold())
                        
                        Text("Respondiste correctamente a \(quizVM.correctCount) de \(quizVM.quiz?.questions.count ?? 0) preguntas 🎉")
                            .font(.body)
                    }
                }
                
                // MARK: Resource Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.resourceType.capitalized)
                        .font(.headline)
                    
                    ScaledText(content.details, style: .body)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                
                // MARK: View Resource Button
                Button(action: {
                    if content.resourceType == "video" {
                        showVideo = true
                    } else {
                        showPDF = true
                    }
                }) {
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
                
                
                // MARK: Quiz Actions
                VStack(spacing: 12) {
                    if quizVM.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        
                        Button {
                            Task {
                                do {
                                    try await quizVM.generateQuiz(content: content)
                                } catch {
                                    errorMessage = "Error al generar quiz: \(error.localizedDescription)"
                                    showErrorAlert = true
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "arrow.clockwise.circle.fill")
                                
                                Text(quizVM.isDone ? "Regenerar Quiz" : "Generar Quiz")
                                    .fontWeight(.bold)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        if quizVM.isDone {
                            Button {
                                showQuiz = true
                            } label: {
                                HStack {
                                    Image(systemName: "questionmark.app.fill")
                                    Text("Realizar Quiz")
                                        .fontWeight(.bold)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.gradient)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                
                // MARK: Progress Button
                Button(action: {
                    guard let progress else { return }
                    
                    switch progress.status {
                    case .notStarted:
                        progress.status = .inProgress
                    case .inProgress:
                        progress.status = .completed
                    case .completed:
                        progress.status = .notStarted
                    }
                    
                    progress.updatedAt = Date()
                    do {
                        try context.save()
                    } catch {
                        errorMessage = "Error al guardar progreso: \(error.localizedDescription)"
                        showErrorAlert = true
                    }
                }) {
                    HStack {
                        Image(systemName: progressStatusIcon)
                            .font(.title2)
                        
                        Text(progressStatus)
                            .font(.title3.bold())
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(progressStatusColor.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
            }
            .padding()
        }
        .padding(40)
        .fullScreenCover(isPresented: $showVideo) {
            VideoView(content: content)
        }
        .fullScreenCover(isPresented: $showPDF) {
            PDFViewerContainer(content: content)
        }
        .onAppear {
            fetchOrCreateProgress()
        }
        .sheet(isPresented: $showQuiz) {
            //Progress is expected to not be nil
            QuestionView(vm : quizVM, progress: progress!)
                .presentationDetents([.large])
        }
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
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
                    local_user_reference: user.id,
                    updatedAt: Date()
                )
                context.insert(newProgress)
                try context.save()
                progress = newProgress
                print("Saved Progress")
            }
        } catch {
            errorMessage = "Error al cargar progreso: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}
#Preview {
    let mockFontSettings = FontSettings()
    mockFontSettings.multiplier = 1.0
    
    DetailContentUserView(content: Content.mockContents[0], user: User.mockUsers[0])
    .environmentObject(mockFontSettings)
}
