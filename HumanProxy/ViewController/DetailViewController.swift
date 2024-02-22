//
//  DetailViewController.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import UIKit

class DetailViewController: UIViewController {

    private let detailView = DetailView()
    private var viewModel: DetailViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, ExchangeRates>?
    
    required init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.detailView
        self.detailView.asset = self.viewModel.asset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.asset.assetID
        
        self.setupCollectionView()
        self.setupCollectionDataSource()
        
        self.viewModel.delegate = self
        Task {
            await self.viewModel.getExchangeRate()
        }
    }
    
    private func setupCollectionView() {
        self.detailView.collectionView.delegate = self
    }
    
    private func setupCollectionDataSource() {
        let registration = UICollectionView.CellRegistration<ExchangeRateCell, ExchangeRates> { cell, indexPath, exchangeRate in
            cell.exchangeRate = exchangeRate
        }
        self.dataSource = UICollectionViewDiffableDataSource<Section, ExchangeRates>(collectionView: self.detailView.collectionView) { collectionView, indexPath, exchangeRate in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: exchangeRate)
        }
    }
    
    private func populate(with rates: [ExchangeRates]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ExchangeRates>()
        snapshot.appendSections([.main])
        snapshot.appendItems(rates)
        self.dataSource?.apply(snapshot)
    }

}

extension DetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension DetailViewController: DetailViewModelDelegate {
    
    func didGetExchangeRates() {
        self.populate(with: self.viewModel.exchangeRates)
        self.viewModel.state = .waiting
        if !self.detailView.exchangeRatesAdded {
            self.detailView.setupExchangeRatesSubviews()
        }
    }
    
    func failedToGetExchangeRates() {
        self.viewModel.state = .waiting
    }
    
}

extension DetailViewController {
    enum Section {
        case main
    }
}

#Preview() {
    let vc = DetailViewController(viewModel: DetailViewModel(asset: ResponseDetailCoinAPIElement.placeholder1(), service: .mock))
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
