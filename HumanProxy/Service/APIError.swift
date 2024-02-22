//
//  APIError.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

enum APIError: Hashable, LocalizedError {
    
    case generic(String)
    case invalidURL
    case parseFailed(String)
    
    var description: String {
        switch self {
        case .generic(let error):           return "Generic Error: \(error)"
        case .invalidURL:                   return "Invalid URL"
        case .parseFailed(let error):       return "Parse Failed: \(error)"
        }
    }
    
}

enum APIMockError: Hashable, LocalizedError {
    
    case failedToLoadMock
    
    var description: String {
        switch self {
        case .failedToLoadMock:             return "Failed to load Mock Data"
        }
    }
    
}
