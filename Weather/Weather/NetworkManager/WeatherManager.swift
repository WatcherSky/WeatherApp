//
//  NetworkManager.swift
//  Evaluation Test App
//
//  Created by Владимир on 03.10.2021.
//

import Foundation
import UIKit

class WeatherManager {
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {  //Make request
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
    
    func getWeather(urlString: String, response: @escaping (String?, _ weather:WeatherModel?) -> Void) {    //get Data and decode them
        request(urlString: urlString) { result in
            switch result {
            case .success(let data):
                do {
                    guard let weather = try JSONDecoder().decode(WeatherData?.self, from: data) else {return}
                    guard let weatherMain = weather.weather.first else {return}
                    let weatherModel = WeatherModel(cityName: weather.name, temperature: weather.main.temp, feelsLikeTemperature: weather.main.feelsLike, windSpeed: weather.wind.speed, humidity: weather.main.humidity, weatherDescription: weatherMain.description, conditionId: weatherMain.id)
                    response(nil, weatherModel)
                } catch let jsonError {
                    self.alert()
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
            }
        }
    }
    
    private func alert() {
        let ac = UIAlertController(title: "Error", message: "City not found, try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {return}
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        rootViewController.present(ac, animated: true, completion: nil)
    }
    
}
