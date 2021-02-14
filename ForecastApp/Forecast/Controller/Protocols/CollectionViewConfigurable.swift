//
//  CollectionViewConfigurable.swift
//  ForecastApp
//
//  Created by Luis Costa on 14/02/2021.
//

import UIKit

protocol CollectionViewConfigurable: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func configure(with viewModel: Any)
    func registerReusableViews(in collectionView: UICollectionView)
}
