//
//  ServiceLive.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

enum RequestTypes: String {
    case get = "GET"
    case post = "POST"
}

enum Endpoint {
    case customEndpoint(String)
    case customURL(String)
    case exchangeRate(String)
    case assets
    
    var endpoint: String {
        switch self {
        case .customEndpoint(let string):   return string
        case .customURL(let string):        return string
        case .exchangeRate(let asset):      return "/exchangerate/\(asset)"
        case .assets:                       return "/assets"
        }
    }
    
    var requestType: RequestTypes {
        return RequestTypes.get
    }
    
}

struct ServiceLive: Services {
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        //decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    private init() {}
    
    static let shared = ServiceLive()
    
}

extension ServiceLive {
    
    func getAssets() async -> Result<ResponseDetailCoinAPI, APIError> {
        do {
            let data = try await self.get(endpoint: .assets)
            let result = try self.jsonDecoder.decode(ResponseDetailCoinAPI.self, from: data)
            return .success(result)
        } catch let decodingError as DecodingError {
            let temp = decodingError
            return .failure(.parseFailed(decodingError.localizedDescription))
        } catch {
            return .failure(.invalidURL)
        }
    }
    
}

extension ServiceLive {
    
    func getExchangeRate(for id: String) async -> Result<ResponseExchangeRatesForID, APIError> {
        do {
            let data = try await self.get(endpoint: .exchangeRate(id))
            let result = try self.jsonDecoder.decode(ResponseExchangeRatesForID.self, from: data)
            return .success(result)
        } catch let decodingError as DecodingError {
            let temp = decodingError
            return .failure(.parseFailed(decodingError.localizedDescription))
        } catch {
            return .failure(.invalidURL)
        }
    }
    
}

fileprivate extension ServiceLive {
    
    func get(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = RequestTypes.get.rawValue
        
        return try await self.get(request: request)
    }
    
    func get(endpoint: Endpoint,
             parameters: [String: String]? = nil,
             queryItems: [URLQueryItem]? = nil) async throws -> Data {
        guard let baseURL = Plist.shared.baseURL(),
              let url = URL(string: baseURL + endpoint.endpoint) else {
            throw APIError.invalidURL
        }
        
        var request: URLRequest = URLRequest(url: url)
        
        if let queryItems {
            request = URLRequest(url: url.appending(queryItems: queryItems))
        }
        
        request.httpMethod = endpoint.requestType.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let api_key = Plist.shared.APIKey() {
            request.setValue(api_key, forHTTPHeaderField: "X-CoinAPI-Key")
        }
        
        if let parameters {
            for param in parameters {
                request.setValue(param.value, forHTTPHeaderField: param.key)
            }
        }
        
        return try await self.get(request: request)
    }
        
    private func get(request: URLRequest) async throws -> Data {
        let session = URLSession.shared
        session.configuration.waitsForConnectivity = true
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.generic("DEBUG: generic")
            }
            return data
        } catch let error as NSError {
            throw APIError.generic("DEBUG: \(error.localizedDescription)")
        }
    }
    
}
