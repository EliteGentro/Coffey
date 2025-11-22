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

    private var mlxVM = MLXModelViewModel()
    private var session: LanguageModelSession = LanguageModelSession()

    /// Generates the quiz using MLX for prompt refinement, then Foundation model for typed Quiz
    func generateQuiz(content: Content) async {
        isLoading = true
        defer { isLoading = false }

        // Ask MLX model to create/refine the quiz prompt
        let initialPrompt =
        """
        Eres una inteligencia artificial encargada de crear contenido educativo para un curso.  
        Genera un cuestionario de 5 preguntas de 4 posibiles opciones múltiples sobre un curso con el título: "\(content.name)" y el siguiente texto o transcripción: "\(content.transcript)".
        
        **Formato requerido:**  

        Pregunta 1: [Texto de la pregunta]  
        0. [Opción 0]  
        1. [Opción 1]  
        2. [Opción 2]  
        3. [Opción 3]  
        Respuesta correcta: [Número de la opción correcta]

        """
        await mlxVM.sendPrompt(initialPrompt)

        // Use the MLX response as the final prompt for the Foundation model
        let refinedPrompt = mlxVM.responseText.isEmpty ? initialPrompt : mlxVM.responseText

        do {
            // Generate the Quiz object directly
            let response = try await session.respond(generating: Quiz.self) {
                Prompt(removeThinkBlocks(from:refinedPrompt))
            }

            quiz = response.content
            currentQuestionIndex = 0
            correctCount = 0
            isDone = true
        } catch {
            print("Failed to generate quiz: \(error)")
        }
    }

    func answerSelected(_ index: Int) {
        guard let quiz = quiz else { return }
        let current = quiz.questions[currentQuestionIndex]
        if index == current.correctIndex-1 {
            correctCount += 1
        }
        currentQuestionIndex += 1
    }

    var isQuizComplete: Bool {
        guard let quiz else { return false }
        return currentQuestionIndex >= quiz.questions.count
    }
    
    func removeThinkBlocks(from text: String) -> String {
        let pattern = "<think>[\\s\\S]*?</think>"
        return text.replacingOccurrences(of: pattern,
                                         with: "",
                                         options: .regularExpression)
    }
}
