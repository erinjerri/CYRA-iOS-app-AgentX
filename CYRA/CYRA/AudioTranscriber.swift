import Foundation
import WhisperKit

class AudioTranscriber {
    private let whisper: WhisperKit

    init() async throws {
        self.whisper = try await WhisperKit()
    }

    func transcribeAudio(from url: URL) async throws -> String {
        let result = try await whisper.transcribe(audioPath: url.path)

        guard let text = result?.text else {
            throw TranscriptionError.noTextFound
        }

        return text
    }

    enum TranscriptionError: Error {
        case noTextFound
    }
}
