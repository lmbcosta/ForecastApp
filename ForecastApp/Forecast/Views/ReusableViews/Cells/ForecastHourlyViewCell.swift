//
//  ForecastHourlyViewCell.swift
//  ForecastApp
//
//  Created by Luis Costa on 14/02/2021.
//

import UIKit

class ForecastHourlyViewCell: UICollectionViewCell {
    static let cellIdentifier = "ForecastHourlyViewCell"
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubsviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubsviews() {
        contentView.addSubview(emojiLabel)
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(hourLabel)
    }
    
    private func addConstraints() {
        emojiLabel.snp.makeConstraints({
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        })
        
        temperatureLabel.snp.makeConstraints({
            $0.top.equalTo(emojiLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        })
        
        hourLabel.snp.makeConstraints({
            $0.top.equalTo(temperatureLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        })
    }
}

extension ForecastHourlyViewCell {
    struct ViewModel {
        let emojiText: String
        let temperature: Double
        let hour: String
    }
    
    func configure(with viewModel: ViewModel) {
        emojiLabel.text = viewModel.emojiText
        temperatureLabel.text = "\(viewModel.temperature) ºC"
        hourLabel.text = viewModel.hour
    }
}
