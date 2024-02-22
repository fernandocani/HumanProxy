//
//  ExchangeRateCell.swift
//  HumanProxy
//
//  Created by Fernando Cani on 22/02/24.
//

import UIKit

class ExchangeRateCell: UICollectionViewListCell {
    
    var exchangeRate: ExchangeRates? {
        didSet {
//            self.imgIcon.kf.setImage(
//                with: self.asset?.getIconURL(),
//                placeholder: self.placeholderImage
//            )
            self.lblName.text = self.exchangeRate?.assetIDQuote
            self.lblID.text = self.exchangeRate?.rate
        }
    }
    
    private(set) lazy var stackViewV: UIStackView = {
        let stackViewV = UIStackView()
        stackViewV.axis = .vertical
        stackViewV.alignment = .fill
        stackViewV.spacing = 8
        stackViewV.translatesAutoresizingMaskIntoConstraints = false
        return stackViewV
    }()
    
    private(set) lazy var stackViewH: UIStackView = {
        let stackViewH = UIStackView()
        stackViewH.axis = .horizontal
        stackViewH.distribution = .fill
        stackViewH.spacing = 8
        stackViewH.translatesAutoresizingMaskIntoConstraints = false
        return stackViewH
    }()
    
    private(set) lazy var stackViewHNumberName: UIStackView = {
        let stackViewH = UIStackView()
        stackViewH.axis = .horizontal
        stackViewH.distribution = .equalSpacing
        stackViewH.spacing = 8
        stackViewH.translatesAutoresizingMaskIntoConstraints = false
        return stackViewH
    }()
    
    private(set) lazy var imgIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = self.placeholderImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private(set) lazy var lblID: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .monospacedSystemFont(ofSize: 12, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var lblName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderImage = UIImage(systemName: "photo.fill")?.withTintColor(.systemGray6, renderingMode: .alwaysOriginal)
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
        self.setupConstraints()
    }
    
    private func setupSubviews() {
        self.contentView.addSubview(self.stackViewV)
        
        self.stackViewV.addArrangedSubview(self.stackViewH)
        self.stackViewH.addArrangedSubview(self.stackViewHNumberName)
        self.stackViewHNumberName.addArrangedSubview(self.lblName)
        self.stackViewHNumberName.addArrangedSubview(self.lblID)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.stackViewV.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            self.stackViewV.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            self.stackViewV.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            self.stackViewV.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -8),
        ])
    }
    
}

#Preview() {
    let cell = ExchangeRateCell()
    cell.exchangeRate = ExchangeRates.placeholder1()
    return cell
}

#Preview() {
    DetailViewController(viewModel: DetailViewModel(asset: .placeholder1(), service: .mock))
}
