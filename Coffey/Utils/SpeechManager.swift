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
    
    let objectWillChange = ObservableObjectPublisher()
    
    private let synthesizer = AVSpeechSynthesizer()
    private let bridge = SpeechSynthesizerDelegateBridge()
    private var utteranceContinuation: CheckedContinuation<Void, Never>?
    
    @Published var isSpeaking: Bool = false
    @Published var currentText: String = ""
    
    private init() {
        bridge.owner = self
        synthesizer.delegate = bridge

        // Activate audio session safely
        Task { @MainActor in
            await activateAudioSession()
        }
    }
    
    @MainActor
        func activateAudioSession() async {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
                try session.setActive(true)
            } catch {
                print("SpeechManager: failed to activate AVAudioSession:", error)
            }
        }
    
    
    
    // MARK: - Public API
    
    func speak(_ text: String, voiceIdentifier: String? = nil, rate: Float = AVSpeechUtteranceDefaultSpeechRate) {
        stop()
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        currentText = trimmed
        isSpeaking = true
        
        let utterance = AVSpeechUtterance(string: trimmed)
        utterance.rate = rate
        if let vid = voiceIdentifier, let voice = AVSpeechSynthesisVoice(identifier: vid) {
            utterance.voice = voice
        }
        
        synthesizer.speak(utterance)
    }
    
    func stop() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        currentText = ""
        resumeContinuationSafely()
    }
    
    func speakAll(_ texts: [String], pause: TimeInterval = 0.4) async {
        stop()
        
        for raw in texts {
            if Task.isCancelled { break }
            let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            await speakAndWait(trimmed)
            
            // Respect cancellation
            do {
                try await Task.sleep(nanoseconds: UInt64(pause * 1_000_000_000))
            } catch {
                break
            }
        }
    }
    
    private func speakAndWait(_ text: String) async {
        currentText = text
        isSpeaking = true
        
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
        
        await withCheckedContinuation { continuation in
            self.utteranceContinuation = continuation
        }
        resumeContinuationSafely()
    }
    
    private func resumeContinuationSafely() {
        if let cont = utteranceContinuation {
            utteranceContinuation = nil
            cont.resume()
        }
    }
    
    // MARK: - Internal helpers (called from delegate bridge)
    
    fileprivate func handleDidStart() {
        isSpeaking = true
    }
    
    fileprivate func handleDidFinish() {
        isSpeaking = false
        currentText = ""
        resumeContinuationSafely()
    }
    
    fileprivate func handleDidCancel() {
        isSpeaking = false
        currentText = ""
        resumeContinuationSafely()
    }
}


/// Delegate bridge to forward events to the main actor safely
private final class SpeechSynthesizerDelegateBridge: NSObject, AVSpeechSynthesizerDelegate {
    weak var owner: SpeechManager?
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        Task { @MainActor in owner?.handleDidStart() }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in owner?.handleDidFinish() }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        Task { @MainActor in owner?.handleDidCancel() }
    }
}
