//
//  WeatherViewController.swift
//  Weather
//
//  Created by Владимир on 07.12.2021.
//

import UIKit

class WeatherViewController: UIViewController {

    private var apikey = "43de0ac13c66a891d31d59320d9bb346"
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    private let weatherPresenter = WeatherPresenter(weatherManager: WeatherManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weatherPresenter.setViewDelegate(weatherDelegate: self)
    }
    
    private func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
}

    

extension WeatherViewController: WeatherDelegate {
    func updateUIWithWeatherData(weather: (cityName: String, temperature: Double, temperatureInt: Int, feelsLikeTemperature: Double, feelsLikeTempInt: Int, icon: String, windSpeed: Double, humidity: Int, weatherDescription: String, condition: Int)) {
        cityLabel.text = weather.cityName
        descriptionLabel.text = "Description: \(weather.weatherDescription)"
        tempLabel.text = "Temperature: \(weather.temperatureInt) C°"
        imageView.image = UIImage(named: weather.icon)
        feelsLikeLabel.text = "FeelsLike: \(weather.feelsLikeTempInt)°"
        humidityLabel.text = "Humidity: \(weather.humidity) %"
        windLabel.text = "WindSpeed: \(weather.windSpeed) m/s"
    }
}

extension WeatherViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else {
            return
        }
        let editedCity = city.replacingOccurrences(of: " ", with: "+")
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(editedCity)&appid=\(apikey)"
        
        weatherPresenter.url = url
        weatherPresenter.getWeatherFromManager()
    }
}
