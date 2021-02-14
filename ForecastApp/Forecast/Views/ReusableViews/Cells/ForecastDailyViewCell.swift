//
//  ForecastDailyViewCell.swift
//  ForecastApp
//
//  Created by Luis Costa on 14/02/2021.
//

import UIKit

class ForecastDailyViewCell: UICollectionViewCell {
    static let cellIdentifier = "ForecastDailyViewCell"
    private var viewModel: ViewModel?
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.register(ForecastHourlyViewCell.self, forCellWithReuseIdentifier: ForecastHourlyViewCell.cellIdentifier)
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubsviews()
        addConstraints()
    }
    
    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubsviews() {
        contentView.addSubview(collectionView)
    }
    
    private func addConstraints() {
        collectionView.snp.makeConstraints({
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
        })
    }
    
}
extension ForecastDailyViewCell {
    struct ViewModel {
        let items: [ForecastHourlyViewCell.ViewModel]
    }
    
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        collectionView.reloadData()
    }
}

extension ForecastDailyViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastHourlyViewCell.cellIdentifier, for: indexPath) as? ForecastHourlyViewCell,
            let hourlyViewModel = viewModel?.items[indexPath.item] else {
            return .init()
        }
        
        cell.configure(with: hourlyViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width / 5
        return .init(width: width, height: 80)
    }
}
