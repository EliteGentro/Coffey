//
//  SpeechManager.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 27/11/25.
//
import Foundation
import Combine
import AVFoundation

@MainActor
final class SpeechManager: ObservableObject {
    static let shared = SpeechManager()
    
    @Published private(set) var isSpeaking: Bool = false
    @Published private(set) var currentText: String = ""
    
    private let synthesizer = AVSpeechSynthesizer()
    private let bridge = SpeechSynthesizerDelegateBridge()
    private var continuation: CheckedContinuation<Void, Never>?

    private init() {
        bridge.owner = self
        synthesizer.delegate = bridge
        
        Task.detached { await self.activateAudioSession() }
    }
    
    nonisolated private func activateAudioSession() async {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("Failed to activate audio session:", error)
        }
    }

    
    // MARK: - Public API
    
    func speak(_ text: String,
               voiceIdentifier: String? = nil,
               rate: Float = AVSpeechUtteranceDefaultSpeechRate)
    {
        stop()

        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        currentText = trimmed  // we know what’s intended to speak
        
        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.rate = rate
        
        if let id = voiceIdentifier,
           let voice = AVSpeechSynthesisVoice(identifier: id) {
            utterance.voice = voice
        }
        
        synthesizer.speak(utterance)
    }
    
    func stop() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
        cleanupAfterStop()
    }
    
    func speakAll(_ texts: [String], pause: TimeInterval = 0.4) async {
        stop()
        
        for text in texts {
            if Task.isCancelled { break }
            
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            
            await speakAndWait(trimmed)
            
            do {
                try await Task.sleep(nanoseconds: UInt64(pause * 1_000_000_000))
            } catch { break }
        }
    }
    
    private func speakAndWait(_ text: String) async {
        currentText = text
        
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
        
        await withCheckedContinuation { continuation in
            self.continuation = continuation
        }
    }
    
    private func cleanupAfterStop() {
        isSpeaking = false
        currentText = ""
        if let cont = continuation {
            continuation = nil
            cont.resume()
        }
    }
    
    // MARK: - Delegate callbacks
    
    fileprivate func didStart() {
        isSpeaking = true
    }
    
    fileprivate func didFinish() {
        cleanupAfterStop()
    }
    
    fileprivate func didCancel() {
        cleanupAfterStop()
    }
}

// MARK: - Delegate Bridge

private final class SpeechSynthesizerDelegateBridge: NSObject, AVSpeechSynthesizerDelegate {
    weak var owner: SpeechManager?
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in owner?.didStart() }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in owner?.didFinish() }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in owner?.didCancel() }
    }
}
