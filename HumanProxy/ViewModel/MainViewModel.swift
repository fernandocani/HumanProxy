//
//  MainViewModel.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

enum LoadingViewModelError: Error, Equatable {
    case playersFetch
}

enum LoadingViewModelState: Equatable {
    case waiting
    case loading
    case finishedLoading
    case error(LoadingViewModelError)
}

protocol MainViewModelDelegate {
    func didSetAssets()
    func failedToSetAssets()
}

@MainActor
final class MainViewModel: ObservableObject {
    
    private(set) var service: ServiceType

    var state: LoadingViewModelState = .waiting
    var assets: [ResponseDetailCoinAPIElement] = []
    var delegate: MainViewModelDelegate?
    
    init(service: ServiceType) {
        self.service = service
    }
    
    func getListInitial() async {
        let result = await self.service.type.getAssets()
        await self.handleResult(result: result)
    }
    
}

extension MainViewModel {
    
    private func handleResult(result: Result<ResponseDetailCoinAPI, APIError>) async {
        switch result {
        case .success(let successList):
            self.assets = successList
            self.delegate?.didSetAssets()
            self.state = .finishedLoading
        case .failure(let error):
            printInfo(error.description)
            self.delegate?.failedToSetAssets()
            self.state = .error(.playersFetch)
        }
    }
    
}
