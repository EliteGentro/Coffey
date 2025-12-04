//
//  ChatView.swift
//  MLXChatExample
//
//  Created by İbrahim Çetin on 20.04.2025.
//

import AVFoundation
import AVKit
import SwiftUI

/// Main chat interface view that manages the conversation UI and user interactions.
/// Displays messages, handles media attachments, and provides input controls.
// MARK: - SwiftUI Test View

struct MLXAITest: View {
    @StateObject private var vm = MLXModelViewModel()
    @State private var prompt = "What is the capital of France?"

    var body: some View {
        ZStack{
            BackgroundView()
        VStack(spacing: 20) {
            TextField("Enter prompt", text: $prompt)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button("Send") {
                Task {
                    await vm.sendPrompt(prompt)
                }
            }

            if vm.isLoading {
                ProgressView()
            } else {
                Text(vm.responseText)
                    .padding()
            }

            if let error = vm.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .padding()
        }
    }
}

// MARK: - Preview

#Preview {
    MLXAITest()
}
