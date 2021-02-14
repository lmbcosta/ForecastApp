//
//  ForecastView.swift
//  ForecastApp
//
//  Created by Luis Costa on 13/02/2021.
//

import UIKit
import SnapKit

class ForecastView: UIView {
    private let cloudsImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        if let image = UIImage(named: "clouds") {
            view.image = image
        }
        return view
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let centerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = true
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func addSubviews() {
        addSubview(cloudsImageView)
        addSubview(leftLabel)
        addSubview(centerLabel)
        addSubview(rightLabel)
        addSubview(bottomView)
        addSubview(collectionView)
    }
    
    private func addConstraints() {
        cloudsImageView.snp.makeConstraints({
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
        })
        
        leftLabel.snp.makeConstraints({
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.top.equalToSuperview().inset(100)
            $0.leading.equalToSuperview().inset(40)
        })
        
        centerLabel.snp.makeConstraints({
            $0.top.equalTo(leftLabel.snp.top)
            $0.trailing.equalTo(rightLabel.snp.leading).offset(-20)
        })
        
        rightLabel.snp.makeConstraints({
            $0.top.equalTo(leftLabel.snp.top)
            $0.trailing.equalToSuperview().inset(40)
        })
        
        bottomView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(cloudsImageView.snp.bottom)
        })
        
        collectionView.snp.makeConstraints({
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(bottomView.snp.top).offset(-40)
        })
    }
}

extension ForecastView {
    struct ViewModel {
        let leftText: String?
        let rightText: String?
        
        var empty: ViewModel {
            .init(leftText: nil, rightText: nil)
        }
    }
    
    func configure(with viewModel: ViewModel) {
        leftLabel.text = viewModel.leftText ?? ""
        rightLabel.text = viewModel.rightText ?? ""
        centerLabel.text = viewModel.rightText != nil ? "It is now" : ""
    }
}
