//
//  ResultsData.swift
//  Evaluation Test App
//
//  Created by Владимир on 02.10.2021.
//

import Foundation

struct Main: Codable {
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case humidity = "humidity"
    }
    let temp: Double
    let feelsLike: Double
    let humidity: Int
}

struct Wind: Codable {
    enum CodingKeys: String, CodingKey {
        case speed = "speed"
    }
    let speed: Double
}

struct Weather: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case description = "description"
    }
    let id: Int
    let description: String
}

struct WeatherData: Codable {
    let name: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
}

