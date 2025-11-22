//
//  ChatViewModel.swift
//  MLXChatExample
//
//  Created by İbrahim Çetin on 20.04.2025.
//

import Foundation
import MLXLMCommon
import UniformTypeIdentifiers

/// ViewModel that manages the chat interface and coordinates with MLXService for text generation.
/// Handles user input, message history, media attachments, and generation state.
@Observable
@MainActor
class ChatViewModel {
    /// Service responsible for ML model operations
    private let mlxService: MLXService

    init(mlxService: MLXService) {
        self.mlxService = mlxService
    }

    /// Current user input text
    var prompt: String = ""

    /// Chat history containing system, user, and assistant messages
    var messages: [Message] = [
        .system("""
                This is a system prompt before your conversation with the user. The next message will be your first interaction with the user.
                You are Arti, a knowledgeable, friendly, and accessible AI art companion. Your role is to provide accurate, engaging, and easy-to-understand explanations of artworks, artists, art movements, and museum exhibits. You assist users in multiple languages and always ensure accessibility in your responses.
                Rules for Arti:
                Accuracy first: Only provide information that is verifiably correct. If you are unsure about a fact, clearly state that you do not know instead of guessing.
                Clarity: Explain art concepts in simple, inclusive language that can be understood by anyone, including beginners.
                Multilingual support: Respond in the user’s preferred language if specified.
                Tour-like guidance: When describing art pieces, provide context, historical background, techniques used, and interesting facts in a narrative style, like a museum guide.
                No hallucination: Avoid inventing artist statements, artwork history, or details. Only relay verified facts.
                Engagement: Encourage curiosity, but remain professional and respectful. Use analogies or comparisons if helpful.
                Accessibility: Describe visual aspects clearly for visually impaired users, including colors, composition, and mood.
                Example Starter Question:
                “Tell me about ‘Starry Night’ by Vincent van Gogh.”
                Example Response:
                “‘Starry Night’ is a painting by Dutch artist Vincent van Gogh, created in 1889 while he was at the Saint-Paul-de-Mausole asylum in France. The painting depicts a night sky swirling with energy above a quiet village. Van Gogh used bold colors and expressive brushstrokes, characteristic of Post-Impressionism. The moon and stars are exaggerated in size to convey emotion rather than realism. This piece is housed at the Museum of Modern Art in New York. I do not have information on any personal statements by Van Gogh about this work that are not verified.”
                Tone and Style:
                Friendly, approachable, curious, and patient. Imagine guiding a visitor through a museum, highlighting important aspects of art without overwhelming them.
                """)
    ]

    /// Currently selected language model for generation
    var selectedModel: LMModel = MLXService.availableModels.first!

    /// Manages image and video attachments for the current message
    var mediaSelection = MediaSelection()

    /// Indicates if text generation is in progress
    var isGenerating = false

    /// Current generation task, used for cancellation
    private var generateTask: Task<Void, any Error>?

    /// Stores performance metrics from the current generation
    private var generateCompletionInfo: GenerateCompletionInfo?

    /// Current generation speed in tokens per second
    var tokensPerSecond: Double {
        generateCompletionInfo?.tokensPerSecond ?? 0
    }

    /// Progress of the current model download, if any
    var modelDownloadProgress: Progress? {
        mlxService.modelDownloadProgress
    }

    /// Most recent error message, if any
    var errorMessage: String?

    /// Generates response for the current prompt and media attachments
    func generate() async {
        // Cancel any existing generation task
        if let existingTask = generateTask {
            existingTask.cancel()
            generateTask = nil
        }

        isGenerating = true

        // Add user message with any media attachments
        messages.append(.user(prompt, images: mediaSelection.images, videos: mediaSelection.videos))
        // Add empty assistant message that will be filled during generation
        messages.append(.assistant(""))

        // Clear the input after sending
        clear(.prompt)

        generateTask = Task {
            // Process generation chunks and update UI
            for await generation in try await mlxService.generate(
                messages: messages, model: selectedModel)
            {
                switch generation {
                case .chunk(let chunk):
                    // Append new text to the current assistant message
                    if let assistantMessage = messages.last {
                        assistantMessage.content += chunk
                    }
                case .info(let info):
                    // Update performance metrics
                    generateCompletionInfo = info
                case .toolCall(_):
                    break
                }
            }
        }

        do {
            // Handle task completion and cancellation
            try await withTaskCancellationHandler {
                try await generateTask?.value
            } onCancel: {
                Task { @MainActor in
                    generateTask?.cancel()

                    // Mark message as cancelled
                    if let assistantMessage = messages.last {
                        assistantMessage.content += "\n[Cancelled]"
                    }
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isGenerating = false
        generateTask = nil
    }

    /// Processes and adds media attachments to the current message
    func addMedia(_ result: Result<URL, any Error>) {
        do {
            let url = try result.get()

            // Determine media type and add to appropriate collection
            if let mediaType = UTType(filenameExtension: url.pathExtension) {
                if mediaType.conforms(to: .image) {
                    mediaSelection.images = [url]
                } else if mediaType.conforms(to: .movie) {
                    mediaSelection.videos = [url]
                }
            }
        } catch {
            errorMessage = "Failed to load media item.\n\nError: \(error)"
        }
    }

    /// Clears various aspects of the chat state based on provided options
    func clear(_ options: ClearOption) {
        if options.contains(.prompt) {
            prompt = ""
            mediaSelection = .init()
        }

        if options.contains(.chat) {
            messages = []
            generateTask?.cancel()
        }

        if options.contains(.meta) {
            generateCompletionInfo = nil
        }

        errorMessage = nil
    }
}

/// Manages the state of media attachments in the chat
@Observable
class MediaSelection {
    /// Controls visibility of media selection UI
    var isShowing = false

    /// Currently selected image URLs
    var images: [URL] = [] {
        didSet {
            didSetURLs(oldValue, images)
        }
    }

    /// Currently selected video URLs
    var videos: [URL] = [] {
        didSet {
            didSetURLs(oldValue, videos)
        }
    }

    /// Whether any media is currently selected
    var isEmpty: Bool {
        images.isEmpty && videos.isEmpty
    }

    private func didSetURLs(_ old: [URL], _ new: [URL]) {
        // the urls we get from fileImporter require SSB calls to access
        new.filter { !old.contains($0) }.forEach { _ = $0.startAccessingSecurityScopedResource() }
        old.filter { !new.contains($0) }.forEach { $0.stopAccessingSecurityScopedResource() }
    }
}

/// Options for clearing different aspects of the chat state
struct ClearOption: RawRepresentable, OptionSet {
    let rawValue: Int

    /// Clears current prompt and media selection
    static let prompt = ClearOption(rawValue: 1 << 0)
    /// Clears chat history and cancels generation
    static let chat = ClearOption(rawValue: 1 << 1)
    /// Clears generation metadata
    static let meta = ClearOption(rawValue: 1 << 2)
}
