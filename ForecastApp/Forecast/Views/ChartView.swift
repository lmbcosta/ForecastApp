//
//  ChartView.swift
//  ForecastApp
//
//  Created by Luis Costa on 13/02/2021.
//

import UIKit
import Charts

final class ChartView: UIView {
    private let chartLineView: LineChartView = {
        let view = LineChartView()
        view.chartDescription?.enabled = true
        view.dragEnabled = false
        view.setScaleEnabled(false)
        view.pinchZoomEnabled = false
        view.leftAxis.enabled = false
        
        let yAxis = view.rightAxis
        yAxis.enabled = true
        yAxis.labelFont = .systemFont(ofSize: 12, weight: .medium)
        yAxis.labelTextColor = .blue
        view.backgroundColor = .white
        yAxis.drawGridLinesEnabled = false
        yAxis.axisLineColor = .blue
        
        view.xAxis.axisLineColor = .blue
        view.xAxis.enabled = true
        view.xAxis.labelPosition = .bottom
        view.xAxis.drawLabelsEnabled = false
        view.xAxis.drawGridLinesEnabled = false
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
        addSubview(chartLineView)
    }
    
    private func addConstraints() {
        chartLineView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
}

extension ChartView {
    struct ViewModel {
        let points: [Point]
    }
    
    struct Point {
        let x: Double
        let y: Double
    }
    
    func configure(with viewModel: ViewModel) {
        let values = viewModel.points.map({
            ChartDataEntry(x: $0.x, y: $0.y)
        })
        
        let set = LineChartDataSet(entries: values, label: "Temperature")
        chartLineView.data = LineChartData(dataSet: set)
    }
}
