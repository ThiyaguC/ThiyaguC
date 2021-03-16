//
//  DataServiceProvider.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//


import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

final class DataServiceProvider {
    
    // MARK: - Get weather details for given city
    func getWeatherForCity(cityName: String, completionHandler: @escaping (Result<WeatherReport>) -> ()) {
        let weatherEndPoint = Constants.DataService.currentWeather + cityName + "&" + Constants.DataService.appID
        guard let url = URL(string: weatherEndPoint) else {
            return completionHandler(.error(kUrlError)) }
        NetworkLayer.getData(url: url, successBlock: { (data) in
            let jsonDecoder = JSONDecoder()
            guard let model = try? jsonDecoder.decode(WeatherReport.self, from: data as! Data) else {
                return completionHandler(.error(kCityError))}
            completionHandler(.success(model))
        } ) { (error) in
            completionHandler(.error(kGenericError))
        }
    }
}
