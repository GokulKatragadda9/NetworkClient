import Foundation

public protocol NetworkClient {
    @discardableResult
    func dataTask<T: Codable>(with url: URL, _ completion: @escaping (Result<T, NetworkClientError>) -> Void) -> URLSessionDataTask
    @discardableResult
    func dataTask<T: Codable>(with request: URLRequest, _ completion: @escaping (Result<T, NetworkClientError>) -> Void) -> URLSessionDataTask
}

public class NetworkClientImpl: NetworkClient {
    private let urlSession = URLSession.shared
    
    public init() {}
    
    @discardableResult
    public func dataTask<T>(with url: URL, _ completion: @escaping (Result<T, NetworkClientError>) -> Void) -> URLSessionDataTask where T : Decodable, T : Encodable {
        let request = URLRequest(url: url)
        return dataTask(with: request, completion)
    }
    
    @discardableResult
    public func dataTask<T>(with request: URLRequest, _ completion: @escaping (Result<T, NetworkClientError>) -> Void) -> URLSessionDataTask where T : Decodable, T : Encodable {
        let dataTask = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                return completion(.failure(.nilSelf))
            }
            
            if let error = error {
                return completion(Result.failure(.error(error: error)))
            }
            
            guard let data = data else {
                return completion(Result.failure(.noDataReceived))
            }
            
            if let data = data as? T {
                return completion(.success(data))
            }
            
            do {
                let result: T = try self.decode(from: data)
                return completion(.success(result))
            } catch let error {
                return completion(.failure(.error(error: error)))
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    private func decode<T: Decodable>(from data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
