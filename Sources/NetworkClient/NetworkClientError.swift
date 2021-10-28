//
//  File.swift
//  
//
//  Created by Gokul Sai Katragadda on 10/27/21.
//

import Foundation

public enum NetworkClientError: Error {
    case urlConstructionFailed
    case decodingError
    case networkError
    case noDataReceived
    case nilSelf
    case error(error: Error)
}
