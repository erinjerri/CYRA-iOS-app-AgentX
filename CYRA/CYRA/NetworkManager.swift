import Foundation

class NetworkManager {
    
    func sendAudioToWhisper(audioURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        // For local WhisperKit processing, you don't need network calls
        // But if you want to use OpenAI's Whisper API, here's how:
        
        // Option 1: Local processing with WhisperKit (recommended)
        processAudioLocally(audioURL: audioURL, completion: completion)
        
        // Option 2: Send to OpenAI Whisper API (uncomment if needed)
        // sendToOpenAIWhisper(audioURL: audioURL, completion: completion)
    }
    
    private func processAudioLocally(audioURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        // Use your AudioTranscriber class here
        let transcriber = AudioTranscriber()
        
        // Use the completion-based method
        transcriber.transcribeAudio(from: audioURL, completion: completion)
    }
    
    private func sendToOpenAIWhisper(audioURL: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let apiKey = getOpenAIAPIKey() else {
            completion(.failure(NetworkError.missingAPIKey))
            return
        }
        
        let url = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        do {
            let audioData = try Data(contentsOf: audioURL)
            let httpBody = createMultipartBody(audioData: audioData, boundary: boundary)
            request.httpBody = httpBody
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.noData))
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let dict = json as? [String: Any],
                       let text = dict["text"] as? String {
                        completion(.success(text))
                    } else {
                        completion(.failure(NetworkError.invalidResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            }.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
    
    private func createMultipartBody(audioData: Data, boundary: String) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    private func getOpenAIAPIKey() -> String? {
        // Add your OpenAI API key here or load from a secure location
        // return "your-api-key-here"
        return nil // Return nil to use local processing instead
    }
}

enum NetworkError: Error, LocalizedError {
    case missingAPIKey
    case noData
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key is missing"
        case .noData:
            return "No data received from server"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}
