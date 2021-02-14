//
//  OpenWeatherService.swift
//  ForecastApp
//
//  Created by Luis Costa on 11/02/2021.
//

import Foundation
import RxSwift

protocol ForecastServiceProtocol {
    func fetchForecastData() -> Single<ForecastModel>
}

final class OpenWeatherService: ForecastServiceProtocol {
    private let apiKey: String
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: .global(qos: .background))
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func fetchForecastData() -> Single<ForecastModel> {
        Single.create(subscribe: { [weak self] observer in
            guard let url = self?.builURL() else {
                observer(.failure(WeatherError.invalidURL))
                return Disposables.create()
            }
            
            print("Resquest: \(url)")
            URLSession.shared.dataTask(with: url, completionHandler: { data , response, error in
                if let error = error {
                    observer(.failure(error))
                    return
                }
                
                guard let data = data else {
                    observer(.failure(WeatherError.emptyData))
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(ForecastModel.self, from: data)
                    observer(.success(response))
                } catch let error {
                    print(error)
                    observer(.failure(WeatherError.parsingJSON))
                }
            })
            .resume()
            
            return Disposables.create()
        })
        .subscribe(on: backgroundScheduler)
    }
    
    // MARK:  Private Functions
    
    private func builURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = Constants.path
        urlComponents.queryItems = buildQueryItems()
        return urlComponents.url
    }
    
    private func buildQueryItems() -> [URLQueryItem] {
        [
            URLQueryItem(name: Constants.cityKey, value: Constants.cityValue),
            URLQueryItem(name: Constants.appIDKey, value: apiKey),
            URLQueryItem(name: Constants.unitsKey, value: Constants.unitsValue)
        ]
    }
    
}

private extension OpenWeatherService {
    struct Constants {
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5/forecast"
        static let cityKey = "q"
        static let cityValue = "porto"
        static let appIDKey = "appid"
        static let unitsKey = "units"
        static let unitsValue = "metric"
        
    }
}
