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
struct Quiz {
    @Guide(description: "A list of 5 quiz questions about the chosen topic.")
    var questions: [QuizQuestion]
}
