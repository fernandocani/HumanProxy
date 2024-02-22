//
//  MainView.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import UIKit

class MainView: UIView {
    
    lazy var compactLayout: UICollectionViewCompositionalLayout = {
        let layout = UICollectionViewCompositionalLayout() { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            let item = NSCollectionLayoutItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return section
        }
        
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.compactLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }()
    
    init() {
        super.init(frame: .zero)
        self.setup()
        self.setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        self.backgroundColor = .systemBackground
    }
    
    func setupSubviews() {
        self.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            self.collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            self.collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
