import AVFoundation
import Foundation

class AudioRecorder: NSObject {
    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?
    private var isRecording = false
    
    override init() throws {
        super.init()
        try setupAudioSession()
        try setupRecorder()
    }
    
    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
        
        // Request microphone permission
        audioSession.requestRecordPermission { allowed in
            if !allowed {
                print("Microphone permission denied")
            }
        }
    }
    
    private func setupRecorder() throws {
        // Create unique filename
        let fileName = "recording_\(Date().timeIntervalSince1970).m4a"
        
        // Get documents directory
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                               in: .userDomainMask).first else {
            throw AudioRecorderError.cannotCreateFile
        }
        
        audioFileURL = documentsDirectory.appendingPathComponent(fileName)
        
        guard let url = audioFileURL else {
            throw AudioRecorderError.cannotCreateFile
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.prepareToRecord()
    }
    
    func startRecording() throws {
        guard let recorder = audioRecorder else {
            throw AudioRecorderError.recorderNotInitialized
        }
        
        guard !isRecording else {
            print("Already recording")
            return
        }
        
        let success = recorder.record()
        if success {
            isRecording = true
            print("Recording started")
        } else {
            throw AudioRecorderError.cannotStartRecording
        }
    }
    
    func stopRecording() {
        guard let recorder = audioRecorder, isRecording else {
            print("Not currently recording")
            return
        }
        
        recorder.stop()
        isRecording = false
        print("Recording stopped")
    }
    
    func getAudioFileURL() -> URL? {
        return audioFileURL
    }
    
    func isCurrentlyRecording() -> Bool {
        return isRecording
    }
    
    // Clean up old recordings if needed
    func deleteRecording() {
        guard let url = audioFileURL else { return }
        
        do {
            try FileManager.default.removeItem(at: url)
            print("Recording deleted")
        } catch {
            print("Error deleting recording: \(error)")
        }
    }
}

// MARK: - AVAudioRecorderDelegate
extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        if flag {
            print("Recording finished successfully")
        } else {
            print("Recording failed")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        isRecording = false
        if let error = error {
            print("Audio recorder encode error: \(error)")
        }
    }
}

// MARK: - Custom Errors
enum AudioRecorderError: Error, LocalizedError {
    case cannotCreateFile
    case recorderNotInitialized
    case cannotStartRecording
    case microphonePermissionDenied
    
    var errorDescription: String? {
        switch self {
        case .cannotCreateFile:
            return "Cannot create audio file"
        case .recorderNotInitialized:
            return "Audio recorder not initialized"
        case .cannotStartRecording:
            return "Cannot start recording"
        case .microphonePermissionDenied:
            return "Microphone permission denied"
        }
    }
}
