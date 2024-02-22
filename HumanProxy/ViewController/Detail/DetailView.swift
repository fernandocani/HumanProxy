//
//  DetailView.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import UIKit
import SwiftUI
import Kingfisher

class DetailView: UIView {
    
    var asset: ResponseDetailCoinAPIElement? {
        didSet {
            if let asset {
                self.imgIcon.kf.setImage(
                    with: asset.getIconURL(),
                    placeholder: self.placeholderImage
                )
                
                if let typeIsCrypto = asset.typeIsCrypto {
                    if typeIsCrypto == 1 {
                        self.lblName.text = (asset.name ?? "-") + " (C)"
                    } else {
                        self.lblName.text = asset.name
                    }
                } else {
                    self.lblName.text = asset.name
                }
                self.lblPriceUSDInfo.text = asset.priceUSDtoCurrency()
            }
        }
    }
    
    private(set) var exchangeRatesAdded: Bool = false
    
    private(set) lazy var scrollViewDetail: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private(set) lazy var stackViewV: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .fill
        stackViewV.distribution = .fill
        stackViewV.spacing = 48
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
    private(set) lazy var stackViewHeader: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .leading
        stackViewV.spacing = 8
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
    private(set) lazy var stackViewContent: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .fill
        stackViewV.spacing = 16
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
    // Number + Types
    private(set) lazy var stackViewHHeader: UIStackView = {
        let stackViewH = UIStackView()
        stackViewH.axis = .horizontal
        stackViewH.distribution = .equalCentering
        stackViewH.spacing = 8
        stackViewH.translatesAutoresizingMaskIntoConstraints = false
        return stackViewH
    }()

    private(set) lazy var lblName: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Icon
    private(set) lazy var stackViewVIcon: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .center
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
    private(set) lazy var imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = self.placeholderImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    // Informations
    private(set) lazy var stackViewVInformations: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .fill
        stackViewV.spacing = 8
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
        // Price USD
    private(set) lazy var stackViewHInformationsPriceUSD: UIStackView = {
        let stackViewH = UIStackView()
        stackViewH.axis = .horizontal
        stackViewH.distribution = .equalCentering
        stackViewH.spacing = 8
        stackViewH.translatesAutoresizingMaskIntoConstraints = false
        return stackViewH
    }()
        
    private(set) lazy var lblPriceUSDTitle: UILabel = {
        let label = UILabel()
        label.text = "Price USD"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var lblPriceUSDInfo: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Chart
    private(set) lazy var chartView: UIView? = {
        let controller = UIHostingController(rootView: SwiftUIChartView(vm: ChartViewModel()))
        guard let view = controller.view else { return nil }
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    /// Collection
    
    private(set) lazy var stackViewVExchangeRates: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .fill
        stackViewV.spacing = 8
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
    private(set) lazy var lblExchangeRatesTitle: UILabel = {
        let label = UILabel()
        label.text = "Exchange Rates"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var compactLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout() { [weak self] sectionIndex, environment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
            return section
        }
        return layout
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.compactLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    /// Placeholder
    private let placeholderImage = UIImage(systemName: "photo.fill")?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
    
    
    init() {
        super.init(frame: .zero)
        self.setup()
        self.setupSubviews()
        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        self.backgroundColor = .secondarySystemBackground
    }
    
    private func setupSubviews() {
        self.addSubview(self.scrollViewDetail)
        
        self.scrollViewDetail.addSubview(self.stackViewV)
        self.stackViewV.addArrangedSubview(self.stackViewHeader)
        self.stackViewV.addArrangedSubview(self.stackViewContent)
        //
        self.stackViewHeader.addArrangedSubview(self.stackViewHHeader)
        self.stackViewHHeader.addArrangedSubview(self.imgIcon)
        self.stackViewHHeader.addArrangedSubview(self.lblName)
        //
        self.stackViewContent.addArrangedSubview(self.stackViewVInformations)
        self.stackViewVInformations.addArrangedSubview(self.stackViewHInformationsPriceUSD)
        self.stackViewHInformationsPriceUSD.addArrangedSubview(self.lblPriceUSDTitle)
        self.stackViewHInformationsPriceUSD.addArrangedSubview(self.lblPriceUSDInfo)
        //
        if let chartView = self.chartView {
            self.stackViewVInformations.addArrangedSubview(chartView)
        }
    }
    
    func setupExchangeRatesSubviews() {
        self.stackViewContent.addArrangedSubview(self.stackViewVExchangeRates)
        self.stackViewVExchangeRates.addArrangedSubview(self.lblExchangeRatesTitle)
        self.stackViewVExchangeRates.addArrangedSubview(self.collectionView)
        self.exchangeRatesAdded = true
    }
    
    private func setupConstraints() {
        let margins = self.layoutMarginsGuide
        NSLayoutConstraint.activate([
            self.scrollViewDetail.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollViewDetail.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            self.scrollViewDetail.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            self.scrollViewDetail.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            self.stackViewV.topAnchor.constraint(equalTo: scrollViewDetail.topAnchor),
            self.stackViewV.leadingAnchor.constraint(equalTo: scrollViewDetail.leadingAnchor),
            self.stackViewV.trailingAnchor.constraint(equalTo: scrollViewDetail.trailingAnchor),
            self.stackViewV.bottomAnchor.constraint(equalTo: scrollViewDetail.bottomAnchor),
            self.stackViewV.widthAnchor.constraint(equalTo: scrollViewDetail.widthAnchor),
        ])
        NSLayoutConstraint.activate([
            self.imgIcon.widthAnchor.constraint(equalToConstant: 24),
            self.imgIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        if let chartView = self.chartView {
            NSLayoutConstraint.activate([
                chartView.heightAnchor.constraint(equalToConstant: 200),
            ])
        }
        NSLayoutConstraint.activate([
            self.collectionView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
    
}

#Preview("2") {
    let vc = DetailViewController(viewModel: DetailViewModel(asset: ResponseDetailCoinAPIElement.placeholder2(), service: .mock))
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}

#Preview("1") {
    let vc = DetailViewController(viewModel: DetailViewModel(asset: ResponseDetailCoinAPIElement.placeholder1(), service: .mock))
    let nav = UINavigationController(rootViewController: vc)
    nav.navigationBar.prefersLargeTitles = true
    return nav
}
