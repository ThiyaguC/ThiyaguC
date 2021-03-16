//
//  AppUtility.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//

import Foundation

let kerror = "Error"
let knetworkError = "The internet connection appears to be offline"
let kGenericError = "Some error occured.Please retry with valid city name"
let kCityError = "City not found"
let kUrlError = "Invalid search"
let kcell = "cell"
let kDefaultCity = "Bangalore"
let kFilledImage = "star.fill"
let kImage = "star"

struct Constants {
    struct DataService {
        static let  currentWeather = "http://api.openweathermap.org/data/2.5/weather?q="
        static let appID = "appid=021bcde5bd986b09c0b756a7ee751929"
    }
}
