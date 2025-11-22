import SwiftUI
import Foundation
import MLXLMCommon
import Combine

// MARK: - ViewModel

@Observable
@MainActor
class MLXModelViewModel:ObservableObject {
    private let mlxService: MLXService = MLXService()

    /// Current prompt string
    var prompt: String = ""

    /// Generated response from the model
    var responseText: String = ""

    /// Indicates if the model is currently generating
    var isLoading: Bool = false

    /// Currently selected model
    var selectedModel: LMModel = MLXService.availableModels.first!

    /// Error message, if generation fails
    var errorMessage: String?

    /// Task used for cancellation
    private var generateTask: Task<Void, Never>?

    /// Sends the prompt to the model and updates responseText
    func sendPrompt(_ prompt: String) async {
        self.prompt = prompt
        isLoading = true
        responseText = ""
        errorMessage = nil
        generateTask?.cancel()

        generateTask = Task { [weak self] in
            guard let self = self else { return }
            // Create a simple user message
            let message = Message(role: .user, content: self.prompt)

            do {
                // Stream MLX model output
                let stream = try await self.mlxService.generate(
                    messages: [message],
                    model: self.selectedModel
                )

                var output = ""
                for try await chunk in stream {
                    if case let .chunk(text) = chunk {
                        output += text
                        self.responseText = output
                    }
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }

            self.isLoading = false
        }

        await generateTask?.value
    }
}

