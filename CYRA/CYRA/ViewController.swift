import UIKit

class ViewController: UIViewController {
    let recorder = AudioRecorder()
    let network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let recordButton = UIButton(type: .system)
        recordButton.setTitle("Record Voice", for: .normal)
        recordButton.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        
        let stopButton = UIButton(type: .system)
        stopButton.setTitle("Stop & Transcribe", for: .normal)
        stopButton.addTarget(self, action: #selector(stopRecordingAndSend), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [recordButton, stopButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func startRecording() {
        recorder.startRecording(fileName: "recordedAudio.m4a")
    }
    
    @objc func stopRecordingAndSend() {
        recorder.stopRecording()
        
        let audioURL = recorder.getAudioFileURL(fileName: "recordedAudio.m4a")
        network.sendAudioToWhisper(audioURL: audioURL) { result in
            DispatchQueue.main.async {
                print("Transcription: \(result)")
            }
        }
    }
}

