//
//  ChartViewCell.swift
//  ForecastApp
//
//  Created by Luis Costa on 14/02/2021.
//

import UIKit

class ChartViewCell: UICollectionViewCell {
    static let cellIdentifier = "ChatViewCell"
    
    private let chartView: ChartView = {
        let view = ChartView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
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
        contentView.addSubview(chartView)
    }
    
    private func addConstraints() {
        chartView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(20)
        })
    }
}
extension ChartViewCell {
    struct ViewModel {
        let chartViewModel: ChartView.ViewModel
    }
    
    func configure(with viewModel: ViewModel) {
        chartView.configure(with: viewModel.chartViewModel)
    }
}
