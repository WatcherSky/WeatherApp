//
//  WeatherPresenter.swift
//  Weather
//
//  Created by Владимир on 06.12.2021.
//

import Foundation

protocol WeatherDelegate {
    func updateUIWithWeatherData(weather: (cityName : String, temperature : Double, temperatureInt: Int, feelsLikeTemperature: Double, feelsLikeTempInt: Int, icon : String, windSpeed : Double, humidity : Int, weatherDescription : String, condition : Int))
}

class WeatherPresenter {
    var weatherDelegate: WeatherDelegate?
    var weatherManager: WeatherManager
    var url = ""
    
    init(weatherManager: WeatherManager){
        self.weatherManager = weatherManager
    }
    
    func setViewDelegate(weatherDelegate: WeatherDelegate?) {
        self.weatherDelegate = weatherDelegate
    }
    
    func getWeatherFromManager() {
        weatherManager.getWeather(urlString: url) { [unowned self] (error, result) in
            if let result = result {
                self.weatherDelegate?.updateUIWithWeatherData(weather: result.weather)
            }
        }
    }
}
