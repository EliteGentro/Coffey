//
//  QuizQuestion.swift
//  AIQuiz
//
//  Created by Humberto Genaro Cisneros Salinas on 12/11/25.
//


import Foundation
import SwiftUI
import Observation
import FoundationModels

// MARK: - AI Generable Data Structures

@Generable
struct QuizQuestion {
    @Guide(description: "The question text for the quiz.")
    var question: String

    @Guide(description: "Four possible answers for the question.")
    var answers: [String]

    @Guide(description: "The index (0-3) of the correct answer in the answers array.")
    var correctIndex: Int
}


