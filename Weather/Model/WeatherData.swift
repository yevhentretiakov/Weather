//
//  WeatherData.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let days: [DayWeather]
}

protocol DateWeather {
    var datetimeEpoch: Int { get }
    var temp: Double { get }
    var icon: String { get }
}

struct DayWeather: Codable, DateWeather {
    let datetimeEpoch: Int
    let tempmax: Double
    let tempmin: Double
    let temp: Double
    let humidity: Double
    let windspeed: Double
    let winddir: Double
    let icon: String
    let hours: [HourWeather]

    var windImage: String {
        switch winddir {
        case 22.5...67.5:
            return "arrow.up.forward"
        case 67.6...112.5:
            return "arrow.forward"
        case 112.6...157.5:
            return "arrow.down.right"
        case 157.6...202.5:
            return "arrow.down"
        case 202.6...247.5:
            return "arrow.down.left"
        case 247.6...292.5:
            return "arrow.backward"
        case 292.6...337.5:
            return "arrow.up.backward"
        case 337.6...360, 0...22.4:
            return "arrow.up"
        default:
            return "arrow.up"
        }
    }
}

struct HourWeather: Codable, DateWeather {
    let datetimeEpoch: Int
    let temp: Double
    let icon: String
}

extension DateWeather {
    var image: String {
        switch self.icon {
        case "snow":
            return "cloud.snow"
        case "rain":
            return "cloud.rain"
        case "fog":
            return "cloud.fog"
        case "wind":
            return "wind"
        case "cloudy":
            return "smoke"
        case "partly-cloudy-day":
            return "cloud.sun"
        case "partly-cloudy-night":
            return "cloud.moon"
        case "clear-day":
            return "cloud.sun"
        case "clear-night":
            return "cloud.moon"
        
        default:
            return "cloud"
        }
    }
}
