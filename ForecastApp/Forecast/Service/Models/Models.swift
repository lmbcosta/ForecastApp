//
//  Models.swift
//  ForecastApp
//
//  Created by Luis Costa on 12/02/2021.
//

import Foundation

struct ForecastModel: Decodable {
    let list: [ForcastDailyModel]
}

struct ForcastDailyModel: Decodable {
    let timestamp: TimeInterval
    let temperature: TemperatureModel
    let weather: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
        case temperature = "main"
        case weather
    }
}

struct TemperatureModel: Decodable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "temp"
    }
}

struct WeatherModel: Decodable {
    let id: Int
    let main: WeatherType
    let description: String
    let icon: String
}

enum WeatherType: String, Decodable {
    case clouds = "Clouds"
    case clear = "Clear"
    case rain = "Rain"
    case drizzle = "Drizzle"
    case thunderstorm = "Thunderstorm"
    case snow = "Snow"
    
    func emoji() -> String {
        switch self {
        case .clear: return "☀️"
        case .clouds: return "☁️"
        case .drizzle: return "🌨"
        case .rain: return "🌧"
        case .thunderstorm: return "⛈"
        case .snow: return "❄️"
        }
    }
}

enum WeatherError: Error {
    case invalidURL
    case emptyData
    case parsingJSON
}
