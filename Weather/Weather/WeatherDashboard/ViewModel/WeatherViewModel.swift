//
//  WeatherDetails.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//

import Foundation
import CoreData

struct WeatherDetails {
    var key: String
    var value: String
    
    func initial(label:String, value: String) {
    }
}

struct WeatherKeyContants {
    static let kCity = "city"
    static let kCityID = "cityID"
    static let kTempStatus = "tempStatus"
    static let kTempDesc = "tempDesc"
    static let kTemp = "temp"
    static let kMinTemp = "Minimum Temperature"
    static let kMaxTemp = "Maximum Temperature"
    static let kFeelslike = "Feels like"
    static let kPressure = "Pressure"
    static let kHumidity = "Humidity"
    static let kWindDegree = "Wind Degree"
    static let kWindSpeed = "Wind Speed"
    static let kSunset = "Sunset"
    static let kSunrise = "Sunrise"
}

class WeatherViewModel {
    
    // MARK: - Properties
    let dataSourceProvider = DataServiceProvider()
    var cityID: Int?
    var temperature: [String:String] = [:]
    var weatherDetailInfo: [WeatherDetails] = []
    let formatter = MeasurementFormatter()
    
    // MARK: - Methods
    func fetchWeatherDetails(city: String, completion: @escaping (_ errorMsg :String?)->()) {
        dataSourceProvider.getWeatherForCity(cityName: city) {(result) in
            switch result {
            case .success(let weather):
                self.weatherDetailInfo.removeAll()
                self.cityID = weather.id
                self.getTemperature(weather: weather)
                self.getWeatherDescriptions(weather: weather)
                completion(nil)
            case .error(let message):
                completion(message)
            }
        }
    }
    
    func checkIfFavCity() -> Bool{
        if let cityID = self.cityID, let cityName = self.temperature[WeatherKeyContants.kCity], let cityTemp = self.temperature[WeatherKeyContants.kTemp] {
            let cityList = CoreDataStack.sharedInstance.isFavouriteCity(cityID: cityID, cityName: cityName, weatherDetails: cityTemp)
            return (cityList > 0)
        }
        return false
    }
    
    func addTofavourite(completionHandler : @escaping (Bool) -> Void) {
        if let cityID = self.cityID, let cityName = self.temperature[WeatherKeyContants.kCity], let cityTemp = self.temperature[WeatherKeyContants.kTemp] {
            CoreDataStack.sharedInstance.addRemoveFromCoreData(cityID: cityID, cityName: cityName, weatherDetails: cityTemp)
            do {
                try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
                completionHandler(true)
            } catch {
                completionHandler(false)
            }
        }
    }
    
    //converting Modal to viewModal for header information
    private func getTemperature(weather: WeatherReport) {
        temperature[WeatherKeyContants.kCity] = weather.name
        temperature[WeatherKeyContants.kTempStatus] = weather.weather?.first?.main
        temperature[WeatherKeyContants.kTempDesc] = weather.weather?.first?.description
        temperature[WeatherKeyContants.kTemp] = convertTemp(temp: weather.main?.temp ?? 0, from: .kelvin, to: .celsius)
    }
    
    //converting Modal to viewModal for table list information
    private func getWeatherDescriptions(weather: WeatherReport) {
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kMinTemp, value: convertTemp(temp: weather.main?.temp_min ?? 0, from: .kelvin, to: .celsius)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kMaxTemp, value: convertTemp(temp: weather.main?.temp_max ?? 0, from: .kelvin, to: .celsius)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kFeelslike, value: convertTemp(temp: weather.main?.feels_like ?? 0, from: .kelvin, to: .celsius)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kPressure, value: String(weather.main?.pressure ?? 0)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kHumidity, value: String(weather.main?.humidity ?? 0)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kWindDegree, value: String(weather.wind?.deg ?? 0)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kWindSpeed, value: String(weather.wind?.speed ?? 0)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kSunset, value: String(weather.sys?.sunset ?? 0)))
        weatherDetailInfo.append(WeatherDetails(key: WeatherKeyContants.kSunrise, value: String(weather.sys?.sunrise ?? 0)))
    }
    
    private func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return formatter.string(from: output)
    }
}
