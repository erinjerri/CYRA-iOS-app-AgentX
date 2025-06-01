import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var transcriber = AudioTranscriber()
    @State private var showingFilePicker = false
    @State private var selectedFileURL: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("CYRA Audio Transcriber")
                .font(.title)
                .fontWeight(.bold)
            
            if transcriber.isTranscribing {
                ProgressView("Transcribing...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                VStack(spacing: 15) {
                    // Option 1: Pick file dynamically
                    Button("Select Audio File") {
                        showingFilePicker = true
                    }
                    .buttonStyle(.borderedProminent)
                    
                    
                    // Option 3: Use file from documents directory
                    Button("Transcribe from Documents") {
                        transcriber.transcribeAudioFromDocuments(fileName: "recorded-audio.m4a")
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            if let selectedURL = selectedFileURL {
                Text("Selected: \(selectedURL.lastPathComponent)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ScrollView {
                Text(transcriber.transcriptionText)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            .frame(maxHeight: 300)
            
            Spacer()
        }
        .padding()
        .fileImporter(
            isPresented: $showingFilePicker,
            allowedContentTypes: [
                UTType.audio,
                UTType.mpeg4Audio,
                UTType.mp3,
                UTType.wav
            ],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result: result)
        }
    }
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else {
                print("No file selected")
                return
            }
            
            selectedFileURL = url
            
            // Start accessing the security-scoped resource
            guard url.startAccessingSecurityScopedResource() else {
                print("Cannot access security scoped resource")
                return
            }
            
            // Transcribe the selected file
            transcriber.transcribeAudio(from: url)
            
            // Stop accessing the security-scoped resource
            url.stopAccessingSecurityScopedResource()
            
        case .failure(let error):
            print("Error selecting file: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
