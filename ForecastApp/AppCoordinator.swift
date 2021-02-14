//
//  AppCoordinator.swift
//  ForecastApp
//
//  Created by Luis Costa on 11/02/2021.
//

import UIKit

final class AppCoordinator {
    static var shared = AppCoordinator()
    
    private init() {}
    
    func buildForecastViewController() -> UIViewController {
        let service = buildService()
        let viewModel = ForecastViewModel(service: service)
        return ForecastViewController(viewModel: viewModel, dataSource: CollectionViewDataSource())
    }
    
    private func weatherAppAPIKey() -> String {
        if
            let dict = Bundle.main.infoDictionary,
            let value =  dict[Strings.weatherAPIKey] as? String {
            print("KEY: \(value)")
            return value
        } else {
            fatalError("Plist file not found")
        }
    }
    
    private func buildService() -> ForecastServiceProtocol {
        let key = weatherAppAPIKey()
        return OpenWeatherService(apiKey: key)
    }
}

extension AppCoordinator {
    struct Strings {
        static let weatherAPIKey = "weatherAPIKey"
    }
}

