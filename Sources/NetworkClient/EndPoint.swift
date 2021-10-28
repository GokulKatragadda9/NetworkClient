//
//  File.swift
//  
//
//  Created by Gokul Sai Katragadda on 10/27/21.
//

import Foundation

public struct EndPoint {
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
    
    public init(host: String, path: String, queryItems: [URLQueryItem]) {
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
    
    public func constructURL() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        guard let url = components.url else {
            throw NetworkClientError.urlConstructionFailed
        }
        return url
    }
    
    public func constructURLRequest(method: HTTPMethod, body: Data?, headers: [String: String]) throws -> URLRequest {
        let url = try constructURL()
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        for field in headers.keys {
            request.setValue(headers[field], forHTTPHeaderField: field)
        }
        return request
    }
}
