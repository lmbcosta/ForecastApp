//
//  DailySectionHeader.swift
//  ForecastApp
//
//  Created by Luis Costa on 14/02/2021.
//

import UIKit

class DailySectionHeader: UICollectionReusableView {
    static let reusableIdentifier = "DailySectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        addSubsviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubsviews() {
        addSubview(titleLabel)
    }
    
    private func addConstraints() {
        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.centerY.equalToSuperview()
        })
    }
}

extension DailySectionHeader {
    struct ViewModel {
        let title: String
    }
    
    func configure(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
    }
}
