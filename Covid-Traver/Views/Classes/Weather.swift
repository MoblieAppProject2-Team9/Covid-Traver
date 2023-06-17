//
//  Weather.swift
//  Covid-Traver
//
//  Created by 임승우 on 2023/06/08.
//
import Foundation

struct WeatherResponse: Decodable{
    let timezone: String
    let current: Current
}

struct Current : Decodable{
    let temp: Double
    let feels_like: Double
    let clouds: Int
    let wind_speed: Double
    let weather: [Weather]
    let name : String
}

struct Weather: Decodable{
    let main: String
    let description: String
    let icon: String
}
