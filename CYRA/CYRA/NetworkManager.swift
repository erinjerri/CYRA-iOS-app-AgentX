import Foundation

class NetworkManager {
    static let shared = NetworkManager()

    func fetchData(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return data
    }

    func sendPostRequest(to urlString: String, with body: [String: Any]) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return data
    }

    func sendAudioToWhisper(audioURL: URL, completion: @escaping (String) -> Void) {
        print("Sending audio to Whisper API: \(audioURL)")
        completion("Transcribed text placeholder") // Simulating API response
    }
}

