import SwiftUI

struct ContentView: View {
    @State private var transcription: String = "Press to record"

    var body: some View {
        VStack(spacing: 20) {
            Text(transcription)
                .padding()

            Button("Record & Transcribe") {
                Task {
                    do {
                        let recorder = try AudioRecorder()
                        try recorder.startRecording()
                        try await Task.sleep(nanoseconds: 5 * 1_000_000_000)
                        recorder.stopRecording()

                        let url = recorder.getLatestRecordingURL()
                        let transcriber = try await AudioTranscriber()
                        let text = try await transcriber.transcribeAudio(from: url)
                        transcription = text
                    } catch {
                        transcription = "Error: \(error.localizedDescription)"
                    }
                }
            }
        }
        .padding()
    }
}
