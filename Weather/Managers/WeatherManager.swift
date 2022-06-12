//
//  WeatherManager.swift
//  Weather
//
//  Created by user on 09.06.2022.
//

import Foundation

class WeatherManager {
    
    private init() {}
    
    static let shared = WeatherManager()
    
    var baseURL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
    
    func fetchWeather(cityName: String) async throws -> [Day] {
        
        let endPoint = "\(baseURL)\(cityName)?unitGroup=metric&key=PZXRTV7AHTLXDM6AJFFESATCB&contentType=json"
        
        guard let url = URL(string: endPoint) else {
            
            throw ErrorMessage.error
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

            throw ErrorMessage.error
        }
        
        do {
            let decoder = JSONDecoder()
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            return weatherData.days
        } catch {

            throw ErrorMessage.error
        }
    }
}
