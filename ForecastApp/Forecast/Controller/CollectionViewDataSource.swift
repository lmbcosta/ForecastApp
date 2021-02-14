//
//  CollectionViewDataSource.swift
//  ForecastApp
//
//  Created by Luis Costa on 13/02/2021.
//

import UIKit

final class CollectionViewDataSource: NSObject {
    var viewModel: Forecast.ViewModel?
    
    private func buildChartCell(_ collectionView: UICollectionView,
                                indexPath: IndexPath,
                                min: Double,
                                max: Double,
                                items: [HourForecastProtocol]) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChartViewCell.cellIdentifier, for: indexPath) as? ChartViewCell else {
            return .init()
        }
        
        let points: [ChartView.Point] = items.compactMap({
            guard let x = Double($0.hour) else { return nil }
            return ChartView.Point(x: x, y: $0.temperature)
        })
        cell.configure(with: .init(chartViewModel: .init(points: points)))
        return cell
    }
    
    private func buildForecastDailyCell(
        _ collectionView: UICollectionView,
        indexPath: IndexPath,
        items: [DailyHourForecastProtocol]) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastDailyViewCell.cellIdentifier, for: indexPath) as? ForecastDailyViewCell else {
            return .init()
        }
        let viewModels = items.compactMap({ ForecastHourlyViewCell.ViewModel(emojiText: $0.weatherEmoji,
                                                                             temperature: $0.temperature,
                                                                             hour: $0.hour) })
        cell.configure(with: .init(items: viewModels))
        return cell
    }
}

// MARK : - CollectionViewConfigurable

extension CollectionViewDataSource: CollectionViewConfigurable {
    func configure(with viewModel: Any) {
        self.viewModel = viewModel as? Forecast.ViewModel
    }
    
    func registerReusableViews(in collectionView: UICollectionView) {
        collectionView.register(ChartViewCell.self,
                                forCellWithReuseIdentifier: ChartViewCell.cellIdentifier)
        collectionView.register(ForecastDailyViewCell.self,
                                forCellWithReuseIdentifier: ForecastDailyViewCell.cellIdentifier)
        collectionView.register(DailySectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: DailySectionHeader.reusableIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            return .init()
        }
        
        switch viewModel.sections[indexPath.section].kind {
        case let .graph(items, min, max):
            return buildChartCell(collectionView, indexPath: indexPath, min: min, max: max, items: items)
        case let .followingDays(items):
            return buildForecastDailyCell(collectionView, indexPath: indexPath, items: items)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DailySectionHeader.reusableIdentifier, for: indexPath) as? DailySectionHeader,
            let viewModel = viewModel,
            let titile = viewModel.sections[indexPath.section].title else {
            return .init()
        }
        
        sectionHeader.configure(viewModel: .init(title: titile))
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard
            viewModel?.sections[section].title != nil else {
            return .zero
        }
              
        let width = collectionView.bounds.width
        return .init(width: width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let viewModel = viewModel else {
            return .zero
        }
        
        let width = collectionView.bounds.width
        
        switch viewModel.sections[indexPath.section].kind {
        case .graph: return .init(width: width, height: 250)
        case .followingDays: return .init(width: width, height: 80)
        }
    }
}


