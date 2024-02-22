//
//  MainViewController.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import UIKit

class MainViewController: UIViewController {

    private let mainView = MainView()
    private var viewModel: MainViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, ResponseDetailCoinAPIElement>?
    
    required init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = switch self.viewModel.service {
        case .live: "HumanProxy"
        case .mock: "HumanProxy" + " - " + self.viewModel.service.title
        }
        self.setupCollectionView()
        self.setupCollectionDataSource()

        self.viewModel.delegate = self
        Task {
            await self.viewModel.getListInitial()
        }
    }

    private func setupCollectionView() {
        self.mainView.collectionView.delegate = self
    }
    
    private func setupCollectionDataSource() {
        let registration = UICollectionView.CellRegistration<MainCollectionViewCell, ResponseDetailCoinAPIElement> { cell, indexPath, asset in
            cell.asset = asset
        }
        self.dataSource = UICollectionViewDiffableDataSource<Section, ResponseDetailCoinAPIElement>(collectionView: self.mainView.collectionView) { collectionView, indexPath, asset in
            collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: asset)
        }
    }
    
    private func populate(with assets: [ResponseDetailCoinAPIElement]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ResponseDetailCoinAPIElement>()
        snapshot.appendSections([.main])
        snapshot.appendItems(assets)
        self.dataSource?.apply(snapshot)
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = self.dataSource,
              let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = DetailViewController(viewModel: DetailViewModel(asset: selectedItem, service: self.viewModel.service))
        self.navigationController?.pushViewController(vc, animated: true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}

extension MainViewController: MainViewModelDelegate {
    
    func didSetAssets() {
        self.populate(with: self.viewModel.assets)
        self.viewModel.state = .waiting
    }
    
    func failedToSetAssets() {
        printInfo("** failedToSetAssets **")
        self.viewModel.state = .waiting
    }
    
}

extension MainViewController {
    enum Section {
        case main
    }
}

#Preview() {
    let vc = MainViewController(viewModel: MainViewModel(service: .mock))
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
