//
//  Services.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

enum ServiceType {
    case live
    case mock
    
    var type: Services {
        switch self {
        case .live: return ServiceLive.shared
        case .mock: return ServiceMock.shared
        }
    }
    var title: String {
        switch self {
        case .live: return "Live"
        case .mock: return "Mock"
        }
    }
}

protocol Services {

    func getAssets() async -> Result<ResponseDetailCoinAPI, APIError>
    func getExchangeRate(for id: String) async -> Result<ResponseExchangeRatesForID, APIError>
    
}
