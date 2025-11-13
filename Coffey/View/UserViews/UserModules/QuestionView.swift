//
//  QuestionView.swift
//  AIQuiz
//
//  Created by Humberto Genaro Cisneros Salinas on 12/11/25.
//

import Foundation
import SwiftUI


struct QuestionView: View {
    @Bindable var vm: QuizViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex: Int? = nil
    @State private var isAnswering = false
    
    var body: some View {
        VStack {
            if let quiz = vm.quiz, vm.currentQuestionIndex < quiz.questions.count {
                let current = quiz.questions[vm.currentQuestionIndex]
                
                VStack(spacing: 24) {
                    Text("Question \(vm.currentQuestionIndex + 1) of \(quiz.questions.count)")
                        .font(.headline)
                    
                    Text(current.question)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    ForEach(current.answers.indices, id: \.self) { idx in
                        Button {
                            handleAnswerSelection(idx, correctIndex: current.correctIndex)
                        } label: {
                            Text(current.answers[idx])
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(buttonBackground(for: idx, correctIndex: current.correctIndex))
                                .cornerRadius(10)
                        }
                        .disabled(isAnswering)
                    }
                    
                    Spacer()
                }
                .padding()
                .animation(.easeInOut, value: selectedIndex)
            }
        }
    }
    
    // MARK: - Answer logic
    
    private func handleAnswerSelection(_ index: Int, correctIndex: Int) {
        guard !isAnswering else { return }
        selectedIndex = index
        isAnswering = true
        
        if index == correctIndex {
            vm.correctCount += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                vm.currentQuestionIndex += 1
                selectedIndex = nil
                isAnswering = false
            }
            
            if vm.isQuizComplete {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    dismiss()
                }
            }
        }
    }
    
    private func buttonBackground(for index: Int, correctIndex: Int) -> Color {
        guard let selectedIndex else {
            return Color.gray.opacity(0.1)
        }
        if index == correctIndex {
            return .green.opacity(0.6)
        } else if index == selectedIndex {
            return .red.opacity(0.6)
        } else {
            return Color.gray.opacity(0.1)
        }
    }
}


#Preview {
    QuestionView(vm:QuizViewModel())
}
