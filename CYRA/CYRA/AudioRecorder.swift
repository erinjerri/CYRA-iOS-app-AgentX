import Foundation
import AVFoundation

class AudioRecorder: ObservableObject {
    @Published var isRecording = false
    private var audioRecorder: AVAudioRecorder?

    func requestMicrophoneAccess() {
        AVAudioApplication.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    print("Microphone access granted")
                } else {
                    print("Microphone access denied")
                }
            }
        }
    }

    func startRecording(fileName: String) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }

    func getAudioFileURL(fileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

