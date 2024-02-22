//
//  ServiceMock.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

struct ServiceMock: Services {
    
    private init() {}
    
    static let shared = ServiceMock()
    
    func getFileData(with name: String) -> Data? {
        if let path = Bundle.main.path(forResource: name, ofType: "json"),
           let data = FileManager.default.contents(atPath: path) {
            return data
        }
        return nil
    }
    
}

extension ServiceMock {
    
    func getAssets() async -> Result<ResponseDetailCoinAPI, APIError> {
        guard let data = self.getFileData(with: "MockResposeGetAssets") else {
            return .failure(.generic("generic: APIMockError.failedToLoadMock"))
        }
        do {
            let response = try JSONDecoder().decode(ResponseDetailCoinAPI.self, from: data)
            return .success(response)
        } catch let error as APIError {
            return .failure(error)
        } catch let error {
            return .failure(.parseFailed("\(error)"))
        }
    }
    
}

extension ServiceMock {
    
    func getExchangeRate(for id: String) async -> Result<ResponseExchangeRatesForID, APIError> {
        guard let data = self.getFileData(with: "MockResponseCurrentRates") else {
            return .failure(.generic("generic: APIMockError.failedToLoadMock"))
        }
        do {
            let response = try JSONDecoder().decode(ResponseExchangeRatesForID.self, from: data)
            return .success(response)
        } catch let error as APIError {
            return .failure(error)
        } catch let error {
            return .failure(.parseFailed("\(error)"))
        }
    }
    
}
