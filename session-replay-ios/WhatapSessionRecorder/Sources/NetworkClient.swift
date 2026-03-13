import Foundation

public enum NetworkError: Error {
    case invalidURL
    case encodingFailed(Error)
    case noDataToSend
    case httpError(Int, Data?)
    case networkError(Error)
}

public class NetworkClient {
    private let session: URLSession
    private let serverURL: URL

    public init(serverURL: String, session: URLSession = .shared) throws {
        guard let url = URL(string: serverURL) else {
            throw NetworkError.invalidURL
        }
        self.serverURL = url
        self.session = session
    }

    public func sendEvents(sessionId: String, events: [EventPayload], completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard !events.isEmpty else {
            completion(.failure(.noDataToSend))
            return
        }

        let endpoint = serverURL.appendingPathComponent("api").appendingPathComponent("events")

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let batch = EventBatch(sessionId: sessionId, events: events)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        do {
            request.httpBody = try encoder.encode(batch)
        } catch {
            completion(.failure(.encodingFailed(error)))
            return
        }

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.httpError(0, data)))
                return
            }

            if (200...299).contains(httpResponse.statusCode) {
                completion(.success(()))
            } else {
                completion(.failure(.httpError(httpResponse.statusCode, data)))
            }
        }

        task.resume()
    }

    public func sendEvents(sessionId: String, events: [EventPayload]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            sendEvents(sessionId: sessionId, events: events) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
