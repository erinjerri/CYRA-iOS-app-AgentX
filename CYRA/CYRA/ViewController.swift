Task {
    do {
        let transcriber = try await AudioTranscriber()
        let url = URL(fileURLWithPath: "path-to-audio.m4a") // Replace with your local file path
        let text = try await transcriber.transcribeAudio(from: url)
        print("Transcript: \(text)")
    } catch {
        print("Error transcribing audio: \(error)")
    }
}

