//
//  ForecastViewModel.swift
//  ForecastApp
//
//  Created by Luis Costa on 13/02/2021.
//

import UIKit
import RxSwift

protocol ForecastViewModelProtocol {
    func fetchForecastData() -> Single<Forecast.ViewModel>
}

final class ForecastViewModel: ForecastViewModelProtocol {
    private let service: ForecastServiceProtocol
    
    init(service: ForecastServiceProtocol) {
        self.service = service
    }
    
    func fetchForecastData() -> Single<Forecast.ViewModel> {
        service
            .fetchForecastData()
            .map({ ViewModelBuilder(model: $0) })
            .flatMap(buildHeader(builder:))
            .flatMap(buildTodaySection(builder:))
            .flatMap(buildFollowingDaysSection(builder:))
            .flatMap(buildViewModel(builder:))
    }
    
    // MARK: - Private functions
    
    private func buildHeader(builder: ViewModelBuilder) -> Single<ViewModelBuilder> {
        Single.create(subscribe: {
            guard let todayModel = builder.model.list.first else {
                $0(.failure(Forecast.PresentationError.missingData))
                return Disposables.create()
            }
            let header =
                Forecast.HeaderViewModel(weatherEmoji: todayModel.weather.first?.main.emoji() ?? "",
                                         tempterature: todayModel.temperature.value)
            $0(.success(builder.setHeader(header)))
            return Disposables.create()
        })
    }
    
    private func buildTodaySection(builder: ViewModelBuilder) -> Single<ViewModelBuilder> {
        Single.create(subscribe: {
            let todayViewModels: [HourForecastProtocol] = builder.model.list.filter({
                let modelDate = Date(timeIntervalSince1970: $0.timestamp)
                return Calendar.current.isDateInToday(modelDate)
            })
            .compactMap({
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH"
                let hour = dateFormatter.string(from: Date(timeIntervalSince1970: $0.timestamp))
                return Forecast.DailyHourForecastViewModel(hour: hour, temperature: $0.temperature.value, weatherEmoji: $0.weather.first?.main.emoji() ?? "", date: nil)
            })
            let min = todayViewModels.min(by: { $0.temperature < $1.temperature })?.temperature ?? 0
            let max = todayViewModels.min(by: { $0.temperature > $1.temperature })?.temperature ?? 0
            
            $0(.success(builder.setToday(.init(title: nil, kind: .graph(items: todayViewModels, min: min, max: max)))))
            
            return Disposables.create()
        })
    }
    
    private func buildFollowingDaysSection(builder: ViewModelBuilder) -> Single<ViewModelBuilder> {
        Single.create(subscribe: {
            var sectionViewModels: [Forecast.SectionViewModel] = []
            var counter = 0
            var hour = 0
            var viewModels: [DailyHourForecastProtocol] = []
            
            
            builder.model.list
                .filter({ !Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.timestamp)) })
                .forEach({
                    if counter < 8 {
                        let date = Date(timeIntervalSince1970: $0.timestamp)
                        viewModels.append(Forecast.DailyHourForecastViewModel(hour: "\(hour)",
                                                                              temperature: $0.temperature.value,
                                                                              weatherEmoji: $0.weather.first?.main.emoji() ?? "",
                                                                              date: date))
                        counter += 1
                        hour += 3
                    }
                    else {
                        let date = viewModels.first?.date ?? .init()
                        sectionViewModels.append(Forecast.SectionViewModel(title: date.formattedDate, kind: .followingDays(items: viewModels)))
                        counter = 0
                        hour = 0
                        viewModels = []
                    }
                })
            $0(.success(builder.setFollowingDays(sectionViewModels)))
            return Disposables.create()
        })
    }
    
    private func buildViewModel(builder: ViewModelBuilder) -> Single<Forecast.ViewModel> {
        Single.create(subscribe: {
            if let viewModel = builder.buildViewModel() {
                $0(.success(viewModel))
            } else {
                $0(.failure(Forecast.PresentationError.missingData))
            }
            return Disposables.create()
        })
    }
}

private extension ForecastViewModel {
    class ViewModelBuilder {
        let model: ForecastModel
        private var header: Forecast.HeaderViewModel?
        private var today: Forecast.SectionViewModel?
        private var followingDays: [Forecast.SectionViewModel]?
        
        init(model: ForecastModel) {
            self.model = model
        }
        
        @discardableResult
        func setHeader(_ header: Forecast.HeaderViewModel) -> Self {
            self.header = header
            return self
        }
        
        @discardableResult
        func setToday(_ today: Forecast.SectionViewModel) -> Self {
            self.today = today
            return self
        }
        
        @discardableResult
        func setFollowingDays(_ followingDays: [Forecast.SectionViewModel]) -> Self {
            self.followingDays = followingDays
            return self
        }
        
        func buildViewModel() -> Forecast.ViewModel? {
            guard
                let header = header,
                let today = today,
                let followingDays = followingDays else {
                return nil
            }
            
            var sections = [Forecast.SectionViewModel]()
            
            if case let .graph(items, _, _) = today.kind,
               !items.isEmpty {
                sections.append(today)
            }
            
            sections.append(contentsOf: followingDays)
            return .init(header: header, sections: sections)
        }
    }
}
