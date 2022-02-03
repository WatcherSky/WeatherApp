//
//  CurrentWeather.swift
//  MyWeather
//
//  Created by Danil Nurgaliev on 20.05.2021.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    var temperatureInt: Int {
        return Int(temperature - Double(273))
    }
    let feelsLikeTemperature: Double
    var feelsLikeTempInt: Int {
        return Int(temperature - Double(273))
    }
    var icon: String { return updateWeatherIcon(condition: conditionId)}
    let windSpeed: Double
    let humidity: Int
    let weatherDescription: String
    let conditionId: Int
    
    
    var weather: (String, Double, Int, Double, Int, String, Double, Int, String, Int){
        return (cityName: cityName,
                temperature: temperature,
                temperatureString: temperatureInt,
                feelsLikeTemperature: feelsLikeTemperature,
                feelsLikeTempString: feelsLikeTempInt,
                icon: icon,
                windSpeed: windSpeed,
                humidity: humidity,
                weatherDescription : weatherDescription,
                conditionId : conditionId)
    }
    
    func updateWeatherIcon(condition: Int?) -> String {
        guard let condition = condition else { return ""}
        switch (condition) {
        case 0...300 :
            return "tstorm1"
        case 301...500 :
            return "light_rain"
            
        case 501...600 :
            return "shower3"
            
        case 601...700 :
            return "snow4"
            
        case 701...771 :
            return "fog"
            
        case 772...799 :
            return "tstorm3"
            
        case 800 :
            return "sunny"
            
        case 801...804 :
            return "cloudy2"
            
        case 900...903, 905...1000  :
            return "tstorm3"
            
        case 903 :
            return "snow5"
            
        case 904 :
            return "sunny"
            
        default :
            return "dunno"
        }
    }
}
