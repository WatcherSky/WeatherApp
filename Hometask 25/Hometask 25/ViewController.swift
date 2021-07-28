//
//  ViewController.swift
//  Hometask 25
//
//  Created by Владимир on 15.07.2021.
//
import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController {
    private var apikey = "43de0ac13c66a891d31d59320d9bb346"
    private var nameCity = "Moscow"
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var locationManager: CLLocationManager?
    private var temp: Double = 0
    private var descriptionOfWeather: String = ""
    private var feelsLike: Double = 0
    private var humidity: Int = 0
    private var speed: Double = 0
    private var id: Int = 0
    private var weather: [Weather]?
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest;
        latitude = locationManager?.location?.coordinate.latitude
        longitude = locationManager?.location?.coordinate.longitude
        
        getWeatherDataByCity(city: nameCity)
    }
    
    private func getWeatherDataByCity(city: String) {
        guard let URL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apikey)") else {
            return
        }
        let request = URLRequest(url: URL)
        nameCity = city
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let weatherDataFromJSON = try? JSONDecoder().decode(WeatherData.self, from: data!)
            
            guard let weather = weatherDataFromJSON?.weather.first else {
                return
            }
            if let weatherDataFromJSON = weatherDataFromJSON {
                self.temp = round(weatherDataFromJSON.main.temp - 273)
                self.descriptionOfWeather = weather.description
                self.feelsLike = round(weatherDataFromJSON.main.feelsLike - 273)
                self.humidity = weatherDataFromJSON.main.humidity
                self.speed = weatherDataFromJSON.wind.speed
                self.id = weather.id
                DispatchQueue.main.async {
                    self.cityLabel.text = self.nameCity
                    self.temperatureLabel.text = "Temperature: \(self.temp) Cº"
                    self.descriptionLabel.text = "Description: \(self.descriptionOfWeather)"
                    self.feelsLikeLabel.text = "FeelsLike: \(self.feelsLike) Cº"
                    self.humidityLabel.text = "Humidity: \(self.id)%"
                    self.windLabel.text = "Wind: \(self.speed) km/h"
                    self.imageView.image = UIImage(systemName: self.getIconImage(idIcon: self.id))
                }
            }
        }
        dataTask.resume()
    }
    
    private func getWeatherDataByCoordinates() {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        let request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=43de0ac13c66a891d31d59320d9bb346&units=metric")!)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let weatherDataFromJSON = try? JSONDecoder().decode(WeatherData.self, from: data!)
            
            guard let weather = weatherDataFromJSON?.weather.first else {
                return
            }
            if let weatherDataFromJSON = weatherDataFromJSON {
                self.temp = round(weatherDataFromJSON.main.temp)
                self.descriptionOfWeather = weather.description
                self.feelsLike = round(weatherDataFromJSON.main.feelsLike)
                self.humidity = weatherDataFromJSON.main.humidity
                self.speed = weatherDataFromJSON.wind.speed
                self.id = weather.id
                DispatchQueue.main.async {
                    self.cityLabel.text = "City: Weather of your city"
                    self.temperatureLabel.text = "Temperature: \(self.temp) Cº"
                    self.descriptionLabel.text = "Description: \(self.descriptionOfWeather)"
                    self.feelsLikeLabel.text = "FeelsLike: \(self.feelsLike) Cº"
                    self.humidityLabel.text = "Humidity: \(self.id)%"
                    self.windLabel.text = "Wind: \(self.speed) km/h"
                    self.imageView.image = UIImage(systemName: self.getIconImage(idIcon: self.id))
                }
            }
        }
        dataTask.resume()
    }
    
    private func getIconImage(idIcon: Int) -> String {
        var systemIconName: String {
            switch idIcon {
            case 200...232:
                return "cloud.bolt.rain.fill"
            case 300...321:
                return "cloud.drizzle.fill"
            case 500...531:
                return "cloud.rain.fill"
            case 600...622:
                return "cloud.snow.fill"
            case 701...781:
                return "smoke.fill"
            case 800:
                return "sun.min.fill"
            case 801...804:
                return "cloud.fill"
            default:
                return "nosign"
            }
        }
        return systemIconName
    }
    
    private func displaySearchAlert() -> String {
        var cityToSearth = ""
        let alert = UIAlertController(title: "Find a City", message: "Enter correct City", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "Chicago"
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                if let _ = textField.text {
                    cityToSearth = textField.text!
                    self.getWeatherDataByCity(city: cityToSearth)
                }
            }))
        }
        self.present(alert, animated: true, completion: nil)
        return cityToSearth
    }
    
    @IBAction func locationButton(_ sender: UIButton) {
        getWeatherDataByCoordinates()
    }
    
    @IBAction private func searchButton(_ sender: UIButton) {
        displaySearchAlert()
    }
}
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

