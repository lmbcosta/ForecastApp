//
//  Forecast.swift
//  ForecastApp
//
//  Created by Luis Costa on 13/02/2021.
//

import Foundation

protocol HourForecastProtocol {
    var hour: String { get }
    var temperature: Double { get }
}

protocol DailyHourForecastProtocol: HourForecastProtocol {
    var weatherEmoji: String { get }
    var date: Date? { get }
}

enum Forecast {
    struct ViewModel {
        let header: HeaderViewModel
        let sections: [SectionViewModel]
    }
    
    struct HeaderViewModel {
        let weatherEmoji: String
        let tempterature: Double
    }
    
    struct SectionViewModel {
        let title: String?
        let kind: Kind
    }
    
    enum Kind {
        case graph(items: [HourForecastProtocol], min: Double, max: Double)
        case followingDays(items: [DailyHourForecastProtocol])
    }
    
    struct DailyHourForecastViewModel: DailyHourForecastProtocol {
        let hour: String
        let temperature: Double
        let weatherEmoji: String
        let date: Date?
    }
    
    enum PresentationError: Error {
        case missingData
    }
}
