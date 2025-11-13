//
//  QuizViewModel.swift
//  AIQuiz
//
//  Created by Humberto Genaro Cisneros Salinas on 12/11/25.
//
import Foundation
import FoundationModels
import Combine

@MainActor
@Observable
class QuizViewModel: ObservableObject {
    var quiz: Quiz?
    var currentQuestionIndex = 0
    var correctCount = 0
    var topic: String = ""
    var isLoading = false
    var isDone = false
    
    private var session: LanguageModelSession = LanguageModelSession()
    
    func generateQuiz( content : Content) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let response = try await session.respond(generating: Quiz.self) {
            """
            Eres una inteligencia artificial encargada de crear contenido educativo para un curso.  
            Genera un cuestionario de 5 preguntas de opción múltiple sobre un curso con el título: "\(content.name)"  
            y el siguiente texto o transcripción: "\(content.transcript)".  

            Cada pregunta debe tener 4 opciones de respuesta y solo una debe ser correcta.  
            Usa un lenguaje claro y sencillo.  
            Asegúrate de que las preguntas estén basadas directamente en la información del texto o transcripción, sin agregar datos que no aparezcan allí.  
            Las preguntas deben ser apropiadas para todo público.
            """
        }
        
        quiz = response.content
        currentQuestionIndex = 0
        correctCount = 0
        isDone = true
    }
    
    func answerSelected(_ index: Int) {
        guard let quiz = quiz else { return }
        let current = quiz.questions[currentQuestionIndex]
        if index == current.correctIndex {
            correctCount += 1
        }
        print(correctCount)
        currentQuestionIndex += 1
    }
    
    var isQuizComplete: Bool {
        guard let quiz else { return false }
        return currentQuestionIndex >= quiz.questions.count
    }
}

