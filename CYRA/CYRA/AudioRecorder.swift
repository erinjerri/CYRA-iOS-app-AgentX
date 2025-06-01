import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    private var audioRecorder: AVAudioRecorder
    private var currentAudioFileURL: URL
    private var recordedURLs: [URL] = []
    
    private let settings = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 12000,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]
    
    override init() throws {
        let defaultURL = FileManager.default.temporaryDirectory.appendingPathComponent("default_recording.m4a")
        self.currentAudioFileURL = defaultURL
        self.audioRecorder = try AVAudioRecorder(url: defaultURL, settings: settings)
        super.init()
        self.audioRecorder.delegate = self
    }
    
    func startRecording() throws {
        if audioRecorder.isRecording {
            print("Recording already in progress")
            return
        }
        
        let timestamp = ISO8601DateFormatter().string(from: Date()).replacingOccurrences(of: ":", with: "-")
        let newURL = FileManager.default.temporaryDirectory.appendingPathComponent("recording_\(timestamp).m4a")
        self.audioRecorder = try AVAudioRecorder(url: newURL, settings: settings)
        self.audioRecorder.delegate = self
        self.currentAudioFileURL = newURL
        
        audioRecorder.record()
        print("Recording started at: \(newURL)")
    }
    
    func stopRecording() {
        guard audioRecorder.isRecording else {
            print("No active recording to stop")
            return
        }
        
        audioRecorder.stop()
        recordedURLs.append(currentAudioFileURL)
        print("Recording stopped, saved at: \(currentAudioFileURL)")
        
        // Reset to a default recorder to maintain non-optional state
        do {
            let defaultURL = FileManager.default.temporaryDirectory.appendingPathComponent("default_recording.m4a")
            self.audioRecorder = try AVAudioRecorder(url: defaultURL, settings: settings)
            self.audioRecorder.delegate = self
            self.currentAudioFileURL = defaultURL
        } catch {
            print("Failed to reset recorder: \(error.localizedDescription)")
        }
    }
    
    func getLatestRecordingURL() -> URL {
        return recordedURLs.last ?? currentAudioFileURL
    }
    
    func getAllRecordedURLs() -> [URL] {
        return recordedURLs
    }
    
    // MARK: - AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("Recording finished successfully at: \(recorder.url)")
        } else {
            print("Recording failed at: \(recorder.url)")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Recording error: \(error.localizedDescription)")
        }
    }
}
