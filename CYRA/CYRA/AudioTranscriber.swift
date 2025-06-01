import Foundation
import WhisperKit
import AVFoundation

class AudioTranscriber: ObservableObject {
    @Published var transcriptionText: String = ""
    @Published var isTranscribing: Bool = false
    
    private var whisperKit: WhisperKit?

    init() {
        setupWhisperKit()
    }

    private func setupWhisperKit() {
        Task {
            do {
                // Initialize WhisperKit with default model
                let whisperInstance = try await WhisperKit()
                await MainActor.run {
                    whisperKit = whisperInstance
                }
            } catch {
                print("Error initializing WhisperKit: \(error)")
            }
        }
    }

    func transcribeAudioFromDocuments(fileName: String) {
        Task {
            do {
                await MainActor.run {
                    guard let whisper = whisperKit else {
                        print("WhisperKit not initialized")
                        return
                    }
                    
                    guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        print("Cannot access documents directory")
                        return
                    }

                    let audioURL = documentsPath.appendingPathComponent(fileName)

                    guard FileManager.default.fileExists(atPath: audioURL.path) else {
                        print("Audio file does not exist at path: \(audioURL.path)")
                        return
                    }
                    
                    isTranscribing = true
                }
                
                let transcriptionResult = try await whisper.transcribe(audioPath: audioURL.path)
                
                await MainActor.run {
                    guard let text = transcriptionResult?.text else {
                        print("No transcription text received")
                        isTranscribing = false
                        return
                    }
                    
                    transcriptionText = text
                    isTranscribing = false
                }
                
                print("Transcription: \(transcriptionText)")

            } catch {
                print("Error transcribing audio: \(error)")
                await MainActor.run {
                    isTranscribing = false
                }
            }
        }
    }
}

