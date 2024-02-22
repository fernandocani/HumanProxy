//
//  DetailViewModel.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

protocol DetailViewModelDelegate {
    func didGetExchangeRates()
    func failedToGetExchangeRates()
}

@MainActor
final class DetailViewModel: ObservableObject {
    
    private(set) var asset: ResponseDetailCoinAPIElement
    private(set) var service: ServiceType

    var state: LoadingViewModelState = .waiting
    var exchangeRates: [ExchangeRates] = []
    var delegate: DetailViewModelDelegate?
    
    init(asset: ResponseDetailCoinAPIElement, service: ServiceType) {
        self.asset = asset
        self.service = service
    }
    
    func getExchangeRate() async {
        if let id = self.asset.assetID {
            let result = await self.service.type.getExchangeRate(for: id)
            await self.handleResult(result: result)
        }
    }
    
}

extension DetailViewModel {
    
    private func handleResult(result: Result<ResponseExchangeRatesForID, APIError>) async {
        switch result {
        case .success(let successList):
            if let rates = successList.rates {
                self.exchangeRates = rates
            }
            self.delegate?.didGetExchangeRates()
            self.state = .finishedLoading
        case .failure(let error):
            printInfo(error.description)
            self.delegate?.failedToGetExchangeRates()
            self.state = .error(.playersFetch)
        }
    }
    
}
